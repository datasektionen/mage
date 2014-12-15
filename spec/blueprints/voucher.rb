Voucher.blueprint do
  title           { "Voucher#{sn}" }
  number          { sn }
  organ           { Organ.make }
  series          { Series.make default_organ: object.organ }
  accounting_date { Date.new(ActivityYear.first.year, 6)  }
  material_from   { User.make }
  bookkept_by     { User.make }
  activity_year   { ActivityYear.first }

  sum = sn.to_i % 1000
  voucher_rows do
    [
      VoucherRow.make(voucher: object, sum: sum),
      VoucherRow.make(voucher: object, sum: -sum)
    ]
  end
end

Voucher.blueprint :without_rows do
  voucher_rows { [] }
end

Voucher.blueprint :not_bookkept do
  number { nil }
  bookkept_by { nil }
end

Voucher.blueprint :invoice_out do
  sum = sn.to_i % 1000
  voucher_rows do
    [
      VoucherRow.make(:type_1, voucher: object, sum: sum),
      VoucherRow.make(voucher: object, sum: -sum)
    ]
  end
end

Voucher.blueprint :invoice_in do
  sum = sn.to_i % 1000
  voucher_rows do
    [
      VoucherRow.make(:type_2, voucher: object, sum: -sum),
      VoucherRow.make(voucher: object, sum: sum)
    ]
  end
end
