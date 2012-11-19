Invoice.blueprint do
  counterpart { "A random company #{sn}" }
  expire_days { 10 }
  supplier_invoice { false }
end

Invoice.blueprint :supplier do
  voucher { Voucher.make(:supplier_invoice) }
  supplier_invoice { true }
end

Invoice.blueprint :normal do
  voucher { Voucher.make(:invoice) }
  supplier_invoice { false }
end
