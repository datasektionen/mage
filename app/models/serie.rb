class Serie < ActiveRecord::Base
  has_many :vouchers
  has_many :user_accesses
  belongs_to :default_organ, :class_name => "Organ"

  scope :accessible_by, lambda {|user|
    if user.admin?
      scoped
    else
      joins(:user_accesses).where("user_accesses.user_id" => user.id)
    end
  }

  def accessible_by?(user)
    user.admin? || Serie.accessible_by(user).include?(self)
  end

  def to_s
    return "#{letter} (#{name})"
  end


end
