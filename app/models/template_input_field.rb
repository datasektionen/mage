class TemplateInputField < ActiveRecord::Base
  belongs_to :template, :inverse_of => :input_fields, :class_name=>"VoucherTemplate", :foreign_key => :voucher_template_id
end
