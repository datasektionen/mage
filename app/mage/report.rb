module Mage
  class Report

    def self.data_from_query(query) 
      result = ActiveRecord::Base.connection.execute(query)
      data = []
      result.each do |r|
        data << Hash[result.fields.zip r]
      end
      data
    end

    ##
    # Get a full report
    # Ignores access rights
    def self.full_report(activity_year, series = nil, organ = nil)
      optional_conditions = ""
      optional_conditions = "and voucher.series_id = #{series.id.to_i}" if !series.nil?
      optional_conditions = "and voucher.organ_id  = #{organ.id.to_i}" if !organ.nil?

      return Mage::Reports::Report.generate(
          self.data_from_query("
                          select
                            accounts.ingoing_balance,
                            voucher_rows.id,
                            voucher_rows.sum,
                            voucher_rows.arrangement_id, 
                            voucher_rows.signature_id,
                            voucher_rows.account_number,
                            vouchers.number as 'voucher_number',
                            vouchers.title as 'voucher_title',
                            vouchers.id as 'voucher_id',
                            vouchers.accounting_date,
                            vouchers.series_id,
                            series.letter as 'series_letter',
                            arrangements.name as 'arrangement_name',
                            organs.id as 'organ_id', organs.name as 'organ_name'
                          from voucher_rows
                             left join arrangements on voucher_rows.arrangement_id = arrangements.id
                             left join organs on arrangements.organ_id = organs.id
                             join vouchers on voucher_rows.voucher_id = vouchers.id 
                             join accounts on accounts.number = voucher_rows.account_number
                             join series on vouchers.series_id = series.id
                          where
                            vouchers.activity_year_id = #{activity_year.id.to_i}
                            and voucher_rows.canceled = 0
                            #{optional_conditions}
                         order by 
                           vouchers.organ_id,
                           voucher_rows.arrangement_id,
                           voucher_rows.account_number,
                           vouchers.accounting_date
                          ")
          )

    end
  end
end
