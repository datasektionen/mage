VoucherTemplate.blueprint do
  name            { "VoucherTemplate#{sn}" }
  description     { "Description#{sn}" }
  template_type   { 0 }

  input_fields {[
    TemplateInputField.make(:template=> object, :script_name=>"#{sn}_input1"),
  ]}

  output_fields {[
    TemplateOutputField.make(:template=>object, :account_number=>Account.make.number, :formula=>"{#{sn}_input}"),
    TemplateOutputField.make(:template=>object, :account_number=>Account.make.number, :formula=>"-1*{#{sn}_input}")
  ]}
end
