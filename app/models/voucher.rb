# -*- encoding: utf-8 -*-

class Voucher < ActiveRecord::Base
  belongs_to :serie
  belongs_to :organ
  belongs_to :activity_year

  has_many :voucher_rows, :inverse_of => :voucher, :before_add=>:check_signature, :before_remove => :check_row_delete

  has_and_belongs_to_many :tags
  has_one :corrected_by, :class_name => "Voucher", :foreign_key => :corrects
  belongs_to :corrects, :class_name => "Voucher", :foreign_key => :corrects
  belongs_to :created_by, :class_name => "User", :foreign_key => :created_by

  before_validation :set_number!

  validates_presence_of :number, :serie, :organ, :accounting_date, :activity_year, :created_by
  validates_uniqueness_of :number, :scope => [:serie_id, :activity_year_id]

  accepts_nested_attributes_for :voucher_rows, :allow_destroy => false

  validate :added_rows_has_signature, :if=>:id
  validate :sum_is_zero

  attr_readonly :number, :serie_id, :organ_id, :accounting_date, :created_by, :activity_year_id

  scope :recent, lambda {|s| 
    where("serie_id = ?", s.id).
    order("created_at DESC")
  }

  def self.search(search, current_activity_year)
    unless search.nil?
      q = where("activity_year_id = ? and title like ?", search[:activity_year], "%#{search[:title]}%")
      q = q.where("serie_id = ?",search[:series]) unless search[:series].empty?
      q
    else
      where("activity_year_id = ?", current_activity_year.id)
    end
  end

  def corrected?
    not corrected_by.nil?
  end

  def pretty_number
    "#{serie.letter}#{number}"
  end

  def set_number!
    if number.nil?
      last_voucher = Voucher.
                      where(:activity_year_id => self.activity_year_id, :serie_id => self.serie).
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
    raise "[Voucher] Tried to delete voucher!"
  end
    
  # sum(abs(row.sum))/2
  def enfoldment
    voucher_rows.reduce(0) {|sum, vr| sum + (vr.canceled? ? 0 : vr.sum.abs) } / 2
  end

  def sum
    voucher_rows.reduce(0) {|sum,vr| sum + (vr.canceled? ? 0 : vr.sum)}
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
    raise "[Voucher] Tried to delete VoucherRows!" unless self.id.nil?
  end

  def check_signature(row) 
    raise "[Voucher] Added row lacks signature" if not self.id.nil? and row.signature.nil? and not current_voucher_rows.include?(row)
  end
  
  def added_rows_has_signature 
    if (voucher_rows-current_voucher_rows).any? {|vr| vr.signature.nil? }
      errors[:base] << "Tillagd rad saknar signatur"
    end
  end

  def sum_is_zero
    errors[:base] << "Summan är inte 0 kr" unless sum == 0
  end
end
