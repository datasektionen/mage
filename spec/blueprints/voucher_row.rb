VoucherRow.blueprint do
  voucher { Voucher.make }
  account  { Account.make }
  sum { sn % 1000 }
  arrangement { Arrangement.make(:organ=>object.voucher.organ) }
end

VoucherRow.blueprint :cancelled do
  cancelled { true }
  signature { User.make }
end

VoucherRow.blueprint :type_1 do
  account  { Account.make(:type_1) }
  arrangement  { nil }
end

VoucherRow.blueprint :type_2 do
  account  { Account.make(:type_2) }
  arrangement  { nil }
end
