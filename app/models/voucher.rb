class Voucher < ActiveRecord::Base
  belongs_to :serie
  belongs_to :organ
  has_one :activity_year

  has_many :voucher_rows, :inverse_of => :voucher, :before_add=>:check_signature, :before_remove => :check_row_delet

  has_and_belongs_to_many :tags
  has_one :corrected_by, :class_name => "Voucher", :foreign_key => :corrects
  belongs_to :corrects, :class_name => "Voucher", :foreign_key => :corrects
  belongs_to :created_by, :class_name => "User", :foreign_key => :created_by

  before_validation :set_number!

  validates_presence_of :number, :serie_id, :organ_id, :accounting_date, :activity_year_id, :created_by
  validates_uniqueness_of :number, :scope => [:serie_id, :activity_year_id]

  accepts_nested_attributes_for :voucher_rows, :allow_destroy => false

  validate :added_rows_has_signature, :if=>:id

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
    raise "[Voucher] Tried to delete voucher!"
  end


  # Returns the voucher_rows set in the database for this voucher
  # or the ones i voucher_rows if id.nil?
  def current_voucher_rows
    return voucher_rows if self.id.nil?
    return VoucherRow.find(:all,:conditions=>{:voucher_id=>self.id})
  end
  # Validations

  def check_row_delet(rows)
    raise "[Voucher] Tried to delete VoucherRows!" unless self.id.nil?
  end

  def check_signature(row) 
    raise "[Voucher] Added row lacks signature" if not self.id.nil? and row.signature.nil?
  end
  
  def added_rows_has_signature 
      if (voucher_rows-current_voucher_rows).any? {|vr| vr.signature.nil? }
        errors[:base] << "Tillagd rad saknar signatur"
      end
  end
end
