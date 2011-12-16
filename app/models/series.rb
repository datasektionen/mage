class Series < ActiveRecord::Base
  has_many :vouchers
  has_many :user_accesses
  belongs_to :default_organ, :class_name => "Organ"

  validates :name, :presence=>true
  validates :letter, :presence=>true

  scope :accessible_by, lambda {|user|
    if user.admin?
      scoped
    else
      joins(:user_accesses).where("user_accesses.user_id" => user.id)
    end
  }

  def accessible_by?(user)
    return true if user.admin?
    accesses = Series.accessible_by(user)
    !accesses.empty? && accesses.include?(self)
  end

  def to_s
    return "#{letter} (#{name})"
  end


end
