Voucher.blueprint do
  title           { "Voucher#{sn}" }
  number          { sn }
  organ           { Organ.make }
  serie           { Serie.make :default_organ => object.organ }
  accounting_date { DateTime.now }
  created_by      { User.make }
  activity_year   { ActivityYear.make }
  voucher_rows    { [VoucherRow.make :voucher => object] }
end
