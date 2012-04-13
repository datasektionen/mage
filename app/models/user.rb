class User < ActiveRecord::Base
  belongs_to :default_series, :class_name => "Series"
  has_many :accesses, :class_name=>"UserAccess"
  has_many :series, :through => :accesses
  has_many :vouchers, :foreign_key => :bookkept_by_id

  devise :omniauthable

  validates_presence_of :first_name, :last_name, :email, :login, :ugid

  extend FriendlyId
  friendly_id :login

  accepts_nested_attributes_for :accesses, :allow_destroy => true

  # String representation of a user
  def to_s
    name
  end

  def cn
    "%s %s (%s)" % [first_name, last_name, login]
  end

  def name
    "%s %s" % [first_name, last_name]
  end

  def admin?
    admin
  end

  def has_access?
    has_access
  end

  # search KTH's LDAP server for a user.
  # This method will return a new User object if it finds any information from the LDAP server.
  # The options hash should contain search filters.
  # The following filters are allowed:
  # * first_name
  # * last_name
  # * ugid
  # * login
  # * email
  # 
  # If supplied with more than one filter, the search will be more specific (first_name=foo & last_name=bar).
  # 
  # Make sure to supply it with specific filters, since it will only return the first user it finds.
  def self.from_ldap(options = {})
    filters = {:givenName   => options[:first_name],
               :sn          => options[:last_name],
               :ugKthid     => options[:ugid],
               :ugUsername  => options[:login],
               :mail        => options[:email]}
    
    filters.reject! {|k,v| v.blank? }
    
    # if we don't have any filters, we won't have to search
    return nil if filters.empty?
    # map filters to proper ldap filters,
    # and join them into a big query
    filter = filters.map do |k,v|
      Net::LDAP::Filter.eq(k,v)
    end.inject {|x,y| x&y }
    
    ldap = Net::LDAP.new( :host => Mage::Application.settings["ldap_host"], 
                          :base => Mage::Application.settings["ldap_basedn"], 
                          :port => Mage::Application.settings["ldap_port"])
    
    ldap.search(:filter => filter) do |u|
      user = new()
      user.first_name = u.givenName.first
      user.last_name = u.sn.first
      user.login = u.ugUsername.first
      user.ugid = u.ugkthid.first
      user.email = u.mail.first
      user.initials = "#{user.first_name.chr}#{user.last_name.chr}".upcase
      return user
    end
    return nil
  end
  
  # Utilize User.from_ldap and save the resulting user.
  # This is for example used by UserSessionController in order to make sure that all logged in CAS users have a corresponding User-object.
  def self.create_from_ldap(options)
    if u = from_ldap(options)
      u.save
      u
    else
      nil
    end
  end

  def self.find_for_cas_oath(access_token, signed_in_resource)
    return nil if access_token.blank?
    if user = User.find_by_ugid(access_token["uid"])
      user
    else
      User.create_from_ldap(:ugid => access_token["uid"])
    end
  end

  def self.find_or_create_by_ugid(ugid)
    u = self.find_by_ugid(ugid)
    if u.nil?
      u = self.create_from_ldap({:ugid=>ugid})
      u.save
      u = self.find_by_ugid(ugid)
    end
    u
  end
end
