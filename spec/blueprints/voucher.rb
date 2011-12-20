Voucher.blueprint do
  title           { "Voucher#{sn}" }
  number          { sn }
  organ           { Organ.make }
  series           { Series.make :default_organ => object.organ }
  accounting_date { DateTime.now }
  material_from   { User.make }
  bookkept_by     { User.make }
  activity_year   { ActivityYear.first }

  sum = sn.to_i % 1000
  voucher_rows {[
    VoucherRow.make(:voucher => object, :sum => sum),
    VoucherRow.make(:voucher => object, :sum => -sum)
  ]}
end

Voucher.blueprint :without_rows do
  voucher_rows { [] }
end

Voucher.blueprint :not_bookkept do
  number {nil}
  bookkept_by {nil}
end
