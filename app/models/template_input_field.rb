class TemplateInputField < ActiveRecord::Base
  belongs_to :template, :inverse_of => :input_fields, :class_name=>"VoucherTemplate"
end
