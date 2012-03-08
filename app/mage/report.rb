module Mage
  class Report
    attr_accessor :organ_reports

    def initialize()
      @organ_reports = []
    end

    ##
    # Generates a report from an sql query. Remember to protect against injections
    def self.generate(query)
      result = ActiveRecord.connection.execute(query)
      data = []
      result.each do |r|
        data << Hash[data.fields.zip r]
      end
     
      report = new()
    
      current_data = []
      current_organ = {:id=>data.first["organs.id"], :name=>data.first["organs.name"]}

      data.each do |d|
        if current_organ.id != d["organs.id"]
          if current_organ.id.nil?
            current_organ = nil # Set the whole organ to nil if the id is nil
          end
          report.organ_reports << Mage::Reports::OrganReport.generate(current_organ, current_data)
          current_organ = {:id=>d["organs.id"], :name=>d["organs.name"]}
          current_data = [d]
        else
          current_data << d
        end
      end
      #Add the last report
      report.organ_reports << Mage::Reports::OrganReport.generate(d)

      report
    end
  end

  ##
  # Get a full report from a year
  def self.full_report(activity_year_id)
    return self.generate("
                        select
                          accounts.number, accounts.ingoing_balance,
                          voucher_rows.*,
                          arrangements.id, arrangements.name,
                          organs.id, organs.name
                        from voucher_rows
                           left join arrangements on voucher_rows.arrangement_id = arrangements.id
                           join vouchers on voucher_rows.voucher_id = vouchers.id 
                           join organs on arrangements.organ_id = organs.id
                           join accounts on accounts.number = voucher_rows.account_number
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
