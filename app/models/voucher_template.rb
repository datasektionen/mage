#-*- encoding: utf-8 -*-
class VoucherTemplate < ActiveRecord::Base
  has_many :input_fields, class_name: 'TemplateInputField', autosave: true
  has_many :output_fields, class_name: 'TemplateOutputField', autosave: true

  validates_associated :input_fields, :output_fields

  validates :template_type, presence: true
  validates :name, presence: true

  accepts_nested_attributes_for :input_fields, allow_destroy: true
  accepts_nested_attributes_for :output_fields, allow_destroy: true

  TYPE_MULTIROW = 0
  TYPE_SINGLEROW = 1

  default_scope where(is_deleted: false)

  scope :in_year, lambda { |year| where('(valid_from IS NULL OR valid_from <= ? ) AND (valid_to IS NULL OR ? <= valid_to)',  year, year) }

  scope :multirow, -> { where("template_type=#{TYPE_MULTIROW}") }
  scope :singlerow, -> { where("template_type=#{TYPE_SINGLEROW}") }

  def parse(fields, arr, activity_year)
    values = {}
    fields.each { |k, f| values[k.to_s] = lambda { |v| $SAFE = 4; eval(v).to_f.round(2) }.call(f.gsub(',', '.')) }
    result = {}
    to_parse = output_fields.clone
    last_size = to_parse.size
    until to_parse.empty?
      to_parse.each do |f|
        r = f.parse(values, arr, activity_year)
        unless r.nil?
          to_parse.delete(f)
          result[f.id] = r unless r.sum == 0
          values[f.script_name] = r.sum unless f.script_name.nil? || f.script_name.empty?
        end
      end
      if to_parse.size == last_size
        fail "Kunde inte parsa alla template fält, har du cirkelreferenser?. Följande fält är kvar: #{to_parse.inspect}."
      else
        last_size = to_parse.size
      end
    end
    result.sort.map { |i| i[1] }
  end

  def has_arrangements?(activity_year)
    output_fields.any? { |f| f.account(activity_year).has_arrangements? }
  end

  def type_string
    I18n.t("activerecord.attributes.voucher_template.template_type_#{template_type}")
  end

  def destroy
    _run_destroy_callbacks { delete }
  end

  def delete
    self.is_deleted = true
    save
  end

  private

  alias_method :shallow_clone, :clone

  public

  def clone
    v = shallow_clone
    v.input_fields = input_fields.map { |f|
      c = f.clone
      c.template = v
      c
    }
    v.output_fields = output_fields.map { |f|
      c = f.clone
      c.template = v
      c
    }
    v
  end
end
