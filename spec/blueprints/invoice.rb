Invoice.blueprint do
  title     { "Invoice#{sn}" }
  direction { :ingoing }
  voucher   { Voucher.make(:invoice_in) }
  status    { :new }
  paid_sum  { sn.to_i * 100 + 0.55 }
  due_days  { 10 + sn.to_i }

end

Invoice.blueprint :outgoing do
  voucher { Voucher.make(:invoice_out) }
  direction { :outgoing }
end
