class Voucher < ActiveRecord::Base
  belongs_to :serie
  belongs_to :organ
  has_one :activity_year

  has_many :voucher_rows, :autosave => true
  has_and_belongs_to_many :tags
  has_one :corrected_by, :class_name => "Voucher", :foreign_key => :corrects
  belongs_to :corrects, :class_name => "Voucher", :foreign_key => :corrects

  validates_uniqueness_of :number, :scope => [:serie_id, :activity_year_id]

  scope :recent, lambda {|s| 
    where("serie_id = ?", s.id).
    order("created_at DESC")
  }

  def corrected?
    not corrected_by.nil?
  end

  def pretty_number
    "#{serie.letter}#{number}"
  end
end
