class Serie < ActiveRecord::Base
  has_many :vouchers
  has_many :user_accesses
  belongs_to :default_organ, :class_name => "Organ"


  scope :accessible_by, lambda {|user|
    if !user.admin?
      joins(:user_accesses).
      where("user_accesses.user_id = ? AND user_accesses.serie_id = ?", user.id, self.id)
    end
  }

  def to_s
    return "#{letter} (#{name})"
  end


end
