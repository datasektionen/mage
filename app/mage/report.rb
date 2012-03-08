module Mage
  class Report
    attr_accessor :organ_reports

    def initialize()
      @organ_reports = []
    end

    def self.data_from_query(query) 
      result = ActiveRecord::Base.connection.execute(query)
      data = []
      result.each do |r|
        data << Hash[result.fields.zip r]
      end
      data
    end
    ##
    # Generates a report from an sql query. Remember to protect against injections
    def self.generate(query)
      data = self.data_from_query(query)

      report = new()
    
      current_data = []
      current_organ = {:id=>data.first["organ_id"], :name=>data.first["organ_name"]}

      data.each do |d|
        if current_organ[:id] != d["organ_id"]
          if current_organ[:id].nil?
            current_organ = nil # Set the whole organ to nil if the id is nil
          end
          report.organ_reports << Mage::Reports::OrganReport.generate(current_organ, current_data)
          current_organ = {:id=>d["organ_id"], :name=>d["organ_name"]}
          current_data = [d]
        else
          current_data << d
        end
      end
      #Add the last report
      report.organ_reports << Mage::Reports::OrganReport.generate(current_organ, current_data)

      report
    end

    ##
    # Get a full report from a year
    def self.full_report(activity_year_id)
      return self.generate("
                          select
                            accounts.ingoing_balance,
                            voucher_rows.*,
                            vouchers.number as 'voucher_number',
                            vouchers.title as 'voucher_title',
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
                            vouchers.activity_year_id = #{activity_year_id.to_i}
                            and voucher_rows.canceled = 0
                         order by 
                           vouchers.organ_id,
                           voucher_rows.arrangement_id,
                           voucher_rows.account_number
                          ")
                            

    end
  end
end
