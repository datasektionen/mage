class Voucher < ActiveRecord::Base
  belongs_to :serie
  belongs_to :organ
  has_one :activity_year

  has_many :voucher_rows, :autosave => true

  has_and_belongs_to_many :tags
  has_one :corrected_by, :class_name => "Voucher", :foreign_key => :corrects
  belongs_to :corrects, :class_name => "Voucher", :foreign_key => :corrects
  belongs_to :created_by, :class_name => "User", :foreign_key => :created_by

  before_validation :set_number!

  validates_presence_of :number, :serie_id, :organ_id, :accounting_date, :activity_year_id, :created_by
  validates_uniqueness_of :number, :scope => [:serie_id, :activity_year_id]

  validate :no_voucher_row_deleted, :if=>:id
  validate :added_rows_has_signature, :if=>:id

  accepts_nested_attributes_for :voucher_rows

  attr_readonly :number, :serie_id, :organ_id, :accounting_date, :created_by, :title, :activity_year_id

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

  def destroy
    Rails.warning "[Voucher] Tried to delete voucher!"
  end

private

  # Returns the voucher_rows set in the database for this voucher
  # or the ones i voucher_rows if id.nil?
  def current_voucher_rows
    return voucher_rows if self.id.nil?
    return VoucherRow.find_by_voucher_id(self.id)
  end

  # Validations
  def no_voucher_row_deleted
    unless current_voucher_rows.all? {|vr| voucher_rows.include? vr }
      errors[:base] << "Rader har raderats"
    end
  end

  def added_rows_has_signature 
    if (voucher_rows-current_voucher_rows).any? {|vr| vr.signature.nil? }
      errors[:base] << "Tillagd rad saknar signatur"
    end
  end
end
