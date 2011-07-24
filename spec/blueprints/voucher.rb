Voucher.blueprint do
  title           { "Voucher#{sn}" }
  number          { sn }
  organ           { Organ.make }
  serie           { Serie.make :default_organ => object.organ }
  accounting_date { DateTime.now }
  created_by      { User.make }
  activity_year   { ActivityYear.make }
  sum = (sn % 1000).to_i
  voucher_rows    {[
    VoucherRow.make(:voucher => object, :sum => sum),
    VoucherRow.make(:voucher => object, :sum => -sum)
  ]}
end
