# -*- encoding: utf-8 -*-
class Voucher < ActiveRecord::Base
  belongs_to :series
  belongs_to :organ
  belongs_to :activity_year

  has_many :voucher_rows, :inverse_of => :voucher, :before_add=>:check_signature, :before_remove => :check_row_delete

  has_and_belongs_to_many :tags
  has_one :corrected_by, :class_name => "Voucher", :foreign_key => :corrects_id
  belongs_to :corrects, :class_name => "Voucher"
  belongs_to :material_from , :class_name => "User"
  belongs_to :authorized_by , :class_name => "User"
  belongs_to :bookkept_by , :class_name => "User"

  belongs_to :api_key

  before_validation :set_number!, :if=>:bookkept_by_id

  validates_presence_of :number, :if=>:bookkept_by_id
  validates_presence_of :series, :organ, :accounting_date, :activity_year, :material_from
  validates_uniqueness_of :number, :scope => [:series_id, :activity_year_id], :if=>:bookkept_by_id

  accepts_nested_attributes_for :voucher_rows, :allow_destroy => true

  validate :added_rows_has_signature, :if=>:bookkept_validation?
  validate :sum_is_zero
  validate :not_empty
  validates_associated :voucher_rows

  validate :accounting_date_in_activity_year

  validate :readonly_if_stagnate 
  attr_readonly  :series_id, :material_from_id, :activity_year_id, :corrects_id, :api_key_id
  attr_writeonce :authorized_by_id, :bookkept_by_id, :number

  extend FriendlyId
  friendly_id :pretty_id, :use=>:slugged

    def normalize_friendly_id(string)
      super.upcase
    end

  default_scope where('bookkept_by_id is not null') # By default only show bookkept vouchers

  scope :recent, lambda {|s| 
    where("series_id = ?", s.id).
    order("created_at DESC")
  }

  searchable do
    integer :activity_year_id
    integer :series_id, :references => Series
    integer :organ_id, :references => Organ

    text :title
    date :accounting_date
    date :created_at
    integer :bookkept_by_id, :references => User

    integer :enfoldment
    boolean :corrected, :using => :corrected?
    boolean :corrects, :using => :corrects?
  end
  
  #Warning, this methods unscopes!
  def self.incomplete
    return unscoped.where("bookkept_by_id is null")
  end

  def self.find_by_account_and_activity_year(account_number, activity_year_id) 
    joins(:voucher_rows).where("voucher_rows.account_number"=>account_number, :activity_year_id=>activity_year_id)
  end

  def corrected?
    not corrected_by.nil?
  end

  def corrects?
    not corrects.nil?
  end

  def pretty_number
    unless number.nil?
      "#{series.letter}#{number}"
    else
      "M---"
    end
  end

  def pretty_id
    unless number.nil?
      "#{activity_year.year}-#{pretty_number}"
    else
      "#{activity_year.year}-#{series.letter}##{self.id}"
    end
  end

  def set_number!
    if number.nil?
      last_voucher = Voucher.
                      where(:activity_year_id => self.activity_year_id, :series_id => self.series).
                      order("number DESC").
                      first(:select=>:number)
      if last_voucher
        self.number = last_voucher.number+1
      else
        self.number = 1
      end
    end
  end

  def destroy
    if bookkept?
      raise "[Voucher] Tried to delete bookkept voucher!"
    else
      voucher_rows.destroy
      super
    end
  end
    
  # sum(abs(row.sum))/2
  def enfoldment
    voucher_rows.reduce(0) {|sum, vr| sum + (vr.canceled? ? 0 : vr.sum.abs) } / 2
  end

  def sum
    voucher_rows.reduce(0) {|sum,vr| sum + (vr.canceled? || vr.marked_for_destruction? ? 0 : vr.sum)}
  end

  def to_s
    return pretty_number
  end 

  # Returns name or name + api key name
  def authorized_by_to_s
    unless authorized_by.nil?
      r = authorized_by.name
      r = "#{r} via #{api_key.name}" unless api_key.nil?
    else
      r = " - "
      r = "Unknown via #{api_key.name}" unless api_key.nil?
    end
    r
  end 

  # Define output in log
  def to_log
    # Pretty - ain't it? :D
    "\n" << voucher_rows.reduce("#{pretty_id} - #{title}
Datum: #{I18n.l accounting_date.to_date}
Nämnd: #{organ}
Underlag från: #{material_from}
Bokfört av: #{bookkept_by}
Attesterat av: #{authorized_by_to_s}
    -----
    ") do |acc,vr|
      acc << "#{vr.to_log}
    "
    end
  end

  # Returns all rows with flipped sum sign
  # By default all canceled rows are ignored, specify :canceled=>true to show them
  def inverted_rows(options={})
    rows = voucher_rows
    rows.reject! {|i| i.canceled? } unless options[:canceled]
    rows.map do |old|
      vr = old.clone
      vr.sum *= -1
      vr
    end
  end

  # Returns true if the voucher is bookkept
  # Notice: A voucher create from api is not bookkept until someone accepts it in mage
  def bookkept?
    return !(bookkept_by.nil? || id.nil?)
  end


  #Used in validations, checks value of _was and not new value
  def bookkept_validation?
    return !(bookkept_by_id_was.nil? || id.nil?)
  end

private

  # Returns the voucher_rows set in the database for this voucher
  # or the ones i voucher_rows if id.nil?
  def current_voucher_rows
    return voucher_rows if self.id.nil?
    return VoucherRow.find(:all,:conditions=>{:voucher_id=>self.id})
  end

  # Validations

  def check_row_delete(rows)
    raise "[Voucher] Tried to delete VoucherRows!" if bookkept_validation?
  end

  def check_signature(row) 
    raise "[Voucher] Added row lacks signature" if bookkept_validation? and row.signature.nil? and not current_voucher_rows.include?(row)
  end
  
  def added_rows_has_signature 
    if (voucher_rows-current_voucher_rows).any? {|vr| vr.signature.nil? }
      errors[:base] << "Tillagd rad saknar signatur"
    end
  end

  def sum_is_zero
    errors[:base] << "Summan är inte 0 kr" unless sum == 0
  end

  def not_empty
    errors[:base] << "Verifikatet är tomt" unless voucher_rows.size > 0
  end
    
  def readonly_if_stagnate
    #:organ_id, :accounting_date
    #TODO: Also check if not stagnated
    if bookkept?
      errors[:organ_id] << I18n.t('activerecord.errors.messages.is_readonly') if changed.include?("organ_id")
      errors[:accounting_date] << I18n.t('activerecord.errors.messages.is_readonly') if changed.include?("accounting_date")
    end
  end

  def accounting_date_in_activity_year
    errors[:accounting_date] << I18n.t('activerecord.errors.messages.must_be_in_activity_year') if !activity_year.in_year?(accounting_date)
  end
end
