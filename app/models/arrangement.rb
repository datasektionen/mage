class Arrangement < ActiveRecord::Base
  belongs_to :organ
  has_many :voucher_rows, :dependent=>:restrict
  validates_presence_of :number, :name, :organ
  validates :number, :uniqueness=>{ :scope => :organ_id }

  scope :in_year, lambda { |year| where("(valid_from IS NULL OR valid_from <= ? ) AND (valid_to IS NULL OR ? <= valid_to)",  year, year) }

  # Other (number==0) must always be valid:
  validates :valid_to, :inclusion=>{ :in=>[nil] , :message=>I18n.t('activerecord.errors.messages.arr_0_may_not_expire') } , :if=> Proc.new { |arr| arr.number == 0 }
  validates :valid_from, :inclusion=>{ :in=>[nil]  , :message=>I18n.t('activerecord.errors.messages.arr_0_may_not_expire') }, :if=> Proc.new { |arr| arr.number == 0}

  attr_readonly :number

  def allow_destroy?
    voucher_rows.empty?
  end

  def in_year?(year)
    return (valid_from.nil? || valid_from <= year) && (valid_to.nil? || year <= valid_to)
  end

  def to_s
    "#{name} (#{number})"
  end

  def list_print
    "#{number} - #{name}"
  end
end
