module Mage
  class Report
    def self.data_from_query(query)
      result = ActiveRecord::Base.connection.execute(query)
      result.map do |r|
        Hash[result.fields.zip(r)]
      end
    end

    ##
    # Get a full report
    def self.full_report(activity_year, series = nil, organ = nil, account = nil)
      conditions = build_conditions(activity_year, series, organ, account)

      Mage::Reports::Report.generate(
        data_from_query(
          <<-SQL
            SELECT
              accounts.ingoing_balance,
              accounts.name AS account_name,
              account_groups.title AS account_group_name,
              account_groups.number AS account_group_number,
              voucher_rows.id,
              voucher_rows.sum,
              voucher_rows.arrangement_id,
              voucher_rows.signature_id,
              voucher_rows.account_number,
              vouchers.number AS voucher_number,
              vouchers.title AS voucher_title,
              vouchers.slug AS voucher_slug,
              vouchers.accounting_date,
              vouchers.series_id,
              series.letter AS series_letter,
              arrangements.name AS arrangement_name,
              arrangements.number AS arrangement_number,
              organs.id AS organ_id, organs.name AS organ_name,
              IF(account_groups.account_type < 3, NULL, organs.number) AS organ_number
            FROM voucher_rows
              LEFT JOIN arrangements ON voucher_rows.arrangement_id = arrangements.id
              JOIN vouchers ON voucher_rows.voucher_id = vouchers.id
              JOIN organs ON vouchers.organ_id = organs.id
              JOIN accounts ON accounts.number = voucher_rows.account_number AND accounts.activity_year_id = vouchers.activity_year_id
              JOIN account_groups ON accounts.account_group_id = account_groups.id
              JOIN series ON vouchers.series_id = series.id
            WHERE
              #{conditions}
            ORDER BY
              organ_number,
              arrangement_number,
              account_groups.number,
              voucher_rows.account_number,
              vouchers.accounting_date
          SQL
        )
      )
    end

    ##
    # Get a summarized report
    def self.full_report_summarized(activity_year, series = nil, organ = nil, account = nil, account_type_filter = nil, invert_sign = false)
      conditions = build_conditions(activity_year, series, organ, account, account_type_filter)
      sign = invert_sign ? '- ' : ''
      Mage::Reports::Report.generate(
          data_from_query(
            <<-SQL
              SELECT
                #{sign}SUM(voucher_rows.sum) AS sum,
                #{sign}SUM(GREATEST(voucher_rows.sum,0)) AS debet,
                #{sign}SUM(LEAST(voucher_rows.sum,0)) AS kredit,
                #{sign}accounts.ingoing_balance,
                accounts.name AS account_name,
                account_groups.title AS account_group_name,
                account_groups.number AS account_group_number,
                voucher_rows.account_number,
                voucher_rows.arrangement_id,
                arrangements.name AS arrangement_name,
                arrangements.number AS arrangement_number,
                organs.id AS organ_id, organs.name AS organ_name,
                IF(account_groups.account_type < 3, NULL, organs.number) AS organ_number
              FROM voucher_rows
                LEFT JOIN arrangements ON voucher_rows.arrangement_id = arrangements.id
                JOIN vouchers ON voucher_rows.voucher_id = vouchers.id
                JOIN organs ON vouchers.organ_id = organs.id
                JOIN accounts ON accounts.number = voucher_rows.account_number AND accounts.activity_year_id = vouchers.activity_year_id
                JOIN account_groups ON accounts.account_group_id = account_groups.id
                JOIN series ON vouchers.series_id = series.id
              WHERE
                #{conditions}
              GROUP BY
                organ_number,
                arrangements.number,
                accounts.number
              ORDER BY
                organ_number,
                arrangement_number,
                account_groups.number,
                accounts.number
          SQL
        )
      )
    end

    ##
    # Get a summarized report (no organs or stuff)
    def self.account_report(activity_year, series = nil, organ = nil, account = nil, account_type_filter = nil, invert_sign = false)
      conditions = build_conditions(activity_year, series, organ, account, account_type_filter)
      sign = invert_sign ? '- ' : ''
      Mage::Reports::Report.generate(
        data_from_query(
          <<-SQL
            SELECT
              #{sign}SUM(voucher_rows.sum) AS sum,
              #{sign}SUM(GREATEST(voucher_rows.sum,0)) AS debet,
              #{sign}SUM(LEAST(voucher_rows.sum,0)) AS kredit,
              #{sign}accounts.ingoing_balance,
              accounts.name AS account_name,
              account_groups.title AS account_group_name,
              account_groups.number AS account_group_number,
              voucher_rows.account_number
            FROM voucher_rows
              LEFT JOIN arrangements ON voucher_rows.arrangement_id = arrangements.id
              JOIN vouchers ON voucher_rows.voucher_id = vouchers.id
              JOIN accounts ON accounts.number = voucher_rows.account_number AND accounts.activity_year_id = vouchers.activity_year_id
              JOIN account_groups ON accounts.account_group_id = account_groups.id
              JOIN series ON vouchers.series_id = series.id
            WHERE
              #{conditions}
            GROUP BY accounts.number
            ORDER BY
              account_groups.number,
              accounts.number
          SQL
        )
      )
    end

    def self.build_conditions(activity_year, series, organs, account, account_type_filter = nil)
      conditions = []
      conditions << Voucher.arel_table[:activity_year_id].eq(activity_year.id)
      conditions << VoucherRow.arel_table[:canceled].eq(0)
      conditions << Voucher.arel_table[:series_id].eq(series.id) if series
      conditions << Voucher.arel_table[:organ_id].in(organs.map(&:id)) if organs
      conditions << VoucherRow.arel_table[:account_number].eq(account.number) if account
      conditions << AccountGroup.arel_table[:account_type].in(account_type_filter) if account_type_filter
      conditions.reduce { |a, e| a.and(e) }.to_sql
    end
  end
end
