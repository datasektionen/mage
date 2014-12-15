class Series < ActiveRecord::Base
  has_many :vouchers
  has_many :user_accesses
  belongs_to :default_organ, class_name: 'Organ'

  validates :name, presence: true
  validates :letter, presence: true

  def to_s
    "#{letter} (#{name})"
  end
end
