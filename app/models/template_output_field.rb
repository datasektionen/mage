#-*- encoding: utf-8 -*-
class TemplateOutputField < ActiveRecord::Base
  belongs_to :template, inverse_of: :output_fields, class_name: 'VoucherTemplate', foreign_key: :voucher_template_id

  validates :account_number, presence: true, numericality: { only_integer: true }
  validates :formula, presence: true

  def parse(values, arr, activity_year)
    complete = true
    gs_formula = formula.gsub(/\{(.+?)\}/) do |m|
      if values.key?(Regexp.last_match[1])
        values[Regexp.last_match[1]]
      elsif template.output_fields.find_by_script_name(Regexp.last_match[1])
        # Depends on a not yet parsed output field
        complete = false
        m # return the match (don't replace)
      else
        fail "Ogiltligt fält i #{script_name} #{account_number}: #{Regexp.last_match[1]}"
      end
    end
    if complete
      sum = eval(gs_formula).round(2)
      arr = account(activity_year).has_arrangements? ? arr : nil
      VoucherRow.new(account: account(activity_year), arrangement_id: arr, sum: sum)
    else
      nil
    end
  end

  def account(activity_year)
    Account.find_by_number_and_activity_year_id(account_number, activity_year)
  end
end
