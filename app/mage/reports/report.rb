module Mage
  module Reports
    class Report
      attr_reader :balance_difference
      attr_accessor :organ_reports

      def initialize()
        @organ_reports = []
      end

      ##
      # Generates a report from an hash of data (TODO: Describe better)
      def self.generate(data)
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

        report.calculate_balance_difference

        report
      end

      def calculate_balance_difference 
        @balance_difference = organ_reports.reduce(0) { |memo, row| memo + row.balance_difference }
      end
    end
  end
end
