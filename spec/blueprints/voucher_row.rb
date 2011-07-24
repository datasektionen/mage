VoucherRow.blueprint do
  voucher { Voucher.make }
  account  { Account.make }
  sum { sn % 1000 }
  arrangement { Arrangement.make }
end

VoucherRow.blueprint :cancelled do
  cancelled { true }
  signature { User.make }
end