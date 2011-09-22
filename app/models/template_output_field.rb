#-*- encoding: utf-8 -*-
class TemplateOutputField < ActiveRecord::Base
  belongs_to :template, :inverse_of => :output_fields, :class_name=>"VoucherTemplate", :foreign_key => :voucher_template_id
  belongs_to :account, :foreign_key => :account_number, :primary_key => :number

  def parse(values,arr) 
    complete = true
    _formula = formula.gsub(/\{(.+?)\}/) do |m|
      if values.key?($1)
        values[$1]
      elsif template.output_fields.find_by_script_name($1)
        # Depends on a not yet parsed output field
        complete = false
        m # return the match (don't replace)
      else
        raise "Ogiltligt fält i #{script_name} #{account_number}: #{$1}"
      end
    end
    if complete
      Rails.logger.debug("#{script_name}: #{_formula}")
      sum = eval(_formula).round(2)
      arr = account.has_arrangements? ? arr : nil
      VoucherRow.new(:account_number=>account_number, :arrangement_id => arr, :sum=>sum)
    else
      nil
    end
  end
end
