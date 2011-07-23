class Voucher < ActiveRecord::Base
  belongs_to :serie
  belongs_to :organ
  has_one :activity_year

  has_many :voucher_rows, :autosave => true

  has_and_belongs_to_many :tags
  has_one :corrected_by, :class_name => "Voucher", :foreign_key => :corrects
  belongs_to :corrects, :class_name => "Voucher", :foreign_key => :corrects

  before_validation :set_number!

  validates_presence_of :number, :serie_id, :organ_id, :accounting_date, :activity_year_id 
  validates_uniqueness_of :number, :scope => [:serie_id, :activity_year_id]

  accepts_nested_attributes_for :voucher_rows

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

  def set_number!
    if number.nil?
      last_voucher = Voucher.
                      where(:activity_year_id => activity_year_id, :serie_id => serie_id).
                      order("number DESC").
                      first(:select=>:number)
      if last_voucher
        self.number = last_voucher.number+1
      else
        self.number = 1
      end
    end
  end
end
