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
    def self.full_report(activity_year, series = nil, organ = nil, account = nil)
      optional_conditions = build_optional_condition(series, organ, account)

      Mage::Reports::Report.generate(
          data_from_query("
                          select
                            accounts.ingoing_balance,
                            accounts.name as 'account_name',
                            account_groups.title as 'account_group_name',
                            account_groups.number as 'account_group_number',
                            voucher_rows.id,
                            voucher_rows.sum,
                            voucher_rows.arrangement_id,
                            voucher_rows.signature_id,
                            voucher_rows.account_number,
                            vouchers.number as 'voucher_number',
                            vouchers.title as 'voucher_title',
                            vouchers.slug as 'voucher_slug',
                            vouchers.accounting_date,
                            vouchers.series_id,
                            series.letter as 'series_letter',
                            arrangements.name as 'arrangement_name',
                            arrangements.number as 'arrangement_number',
                            organs.id as 'organ_id', organs.name as 'organ_name',
                            IF(account_groups.account_type < 3, NULL, organs.number) as 'organ_number'
                          from voucher_rows
                             left join arrangements on voucher_rows.arrangement_id = arrangements.id
                             join vouchers on voucher_rows.voucher_id = vouchers.id
                             join organs on vouchers.organ_id = organs.id
                             join accounts on accounts.number = voucher_rows.account_number and accounts.activity_year_id = vouchers.activity_year_id
                             join account_groups on accounts.account_group_id = account_groups.id
                             join series on vouchers.series_id = series.id
                          where
                            vouchers.activity_year_id = #{activity_year.id.to_i}
                            and voucher_rows.canceled = 0
                            #{optional_conditions}
                         order by
                          organ_number,
                           arrangement_number,
                           account_groups.number,
                           voucher_rows.account_number,
                           vouchers.accounting_date
                          ")
          )
    end

    ##
    # Get a summarized report
    def self.full_report_summarized(activity_year, series = nil, organ = nil, account = nil, account_type_filter = nil, invert_sign = false)
      optional_conditions = build_optional_condition(series, organ, account, account_type_filter)
      sign = invert_sign ? '- ' : ''
      Mage::Reports::Report.generate(
          data_from_query("
                          select
                            #{sign}SUM(voucher_rows.sum) as 'sum',
                            #{sign}SUM(GREATEST(voucher_rows.sum,0)) as 'debet',
                            #{sign}SUM(LEAST(voucher_rows.sum,0)) as 'kredit',
                            #{sign}accounts.ingoing_balance,
                            accounts.name as 'account_name',
                            account_groups.title as 'account_group_name',
                            account_groups.number as 'account_group_number',
                            voucher_rows.account_number,
                            voucher_rows.arrangement_id,
                            arrangements.name as 'arrangement_name',
                            arrangements.number as 'arrangement_number',
                            organs.id as 'organ_id', organs.name as 'organ_name',
                            IF(account_groups.account_type < 3, NULL, organs.number) as 'organ_number'
                          from voucher_rows
                             left join arrangements on voucher_rows.arrangement_id = arrangements.id
                             join vouchers on voucher_rows.voucher_id = vouchers.id
                             join organs on vouchers.organ_id = organs.id
                             join accounts on accounts.number = voucher_rows.account_number and accounts.activity_year_id = vouchers.activity_year_id
                             join account_groups on accounts.account_group_id = account_groups.id
                             join series on vouchers.series_id = series.id
                          where
                            vouchers.activity_year_id = #{activity_year.id.to_i}
                            and voucher_rows.canceled = 0
                            #{optional_conditions}
                         group by organ_number, arrangements.number, accounts.number
                         order by
                           organ_number,
                           arrangement_number,
                           account_groups.number,
                           accounts.number
                          ")
          )
    end

    ##
    # Get a summarized report (no organs or stuff)
    def self.account_report(activity_year, series = nil, organ = nil, account = nil, account_type_filter = nil, invert_sign = false)
      optional_conditions = build_optional_condition(series, organ, account, account_type_filter)
      sign = invert_sign ? '- ' : ''
      Mage::Reports::Report.generate(
          data_from_query("
                          select
                            #{sign}SUM(voucher_rows.sum) as 'sum',
                            #{sign}SUM(GREATEST(voucher_rows.sum,0)) as 'debet',
                            #{sign}SUM(LEAST(voucher_rows.sum,0)) as 'kredit',
                            #{sign}accounts.ingoing_balance,
                            accounts.name as 'account_name',
                            account_groups.title as 'account_group_name',
                            account_groups.number as 'account_group_number',
                            voucher_rows.account_number
                            from voucher_rows
                             left join arrangements on voucher_rows.arrangement_id = arrangements.id
                             join vouchers on voucher_rows.voucher_id = vouchers.id
                             join accounts on accounts.number = voucher_rows.account_number and accounts.activity_year_id = vouchers.activity_year_id
                             join account_groups on accounts.account_group_id = account_groups.id
                             join series on vouchers.series_id = series.id
                          where
                            vouchers.activity_year_id = #{activity_year.id.to_i}
                            and voucher_rows.canceled = 0
                            #{optional_conditions}
                         group by accounts.number
                         order by
                           account_groups.number,
                           accounts.number
                          ")
          )
    end

    def self.build_optional_condition(series, organs, account, account_type_filter = nil)
      optional_conditions = ''
      optional_conditions += " and vouchers.series_id = #{series.id.to_i}" unless series.nil?
      optional_conditions += " and vouchers.organ_id IN (#{organs.map { |o| o.id.to_i }.join(',') })" unless organs.nil?
      optional_conditions += " and voucher_rows.account_number = #{account.number.to_i}" unless account.nil?
      optional_conditions += " and account_groups.account_type IN (#{account_type_filter.join(',')})"  unless account_type_filter.nil?

      optional_conditions
    end
  end
end
