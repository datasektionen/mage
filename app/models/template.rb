class Template < ActiveRecord::Base
  has_many :template_input_fields
  has_many :template_output_fields
end
