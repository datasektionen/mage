class Serie < ActiveRecord::Base
  has_many :vouchers
  has_and_belongs_to_many :organs
  has_many :user_accesses
  belongs_to :default_organ, :class_name => "Organ"

  scope :accessible_by, lambda {|user|
    if !user.admin?
      joins(:user_accesses).
      where("user_accesses.user_id = ? AND user_accesses.serie_id = ?", user.id, self.id)
    end
  }

  def title
    return "#{letter} (#{name})"
  end

end
