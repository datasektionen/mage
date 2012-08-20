Invoice.blueprint do
  title     { "Invoice#{sn}" }
  direction { :ingoing }
  voucher   { Voucher.make(:invoice_in) }
  status    { :new }
  due_days  { 10 + sn.to_i }
  number    { "I#{sn}" }
end

Invoice.blueprint :ingoing do
  voucher { Voucher.make(:invoice_in) }
  direction { :ingoing }
end

Invoice.blueprint :outgoing do
  voucher { Voucher.make(:invoice_out) }
  direction { :outgoing }
end
