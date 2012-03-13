module Mage
  module Reports
    class Report
      attr_reader :balance_difference
      attr_accessor :arrangement_reports

      def initialize()
        @arrangement_reports = []
      end

      ##
      # Generates a report from an hash of data (TODO: Describe better)
      def self.generate(data)
        report = new()
      
        current_data = []
        current_arr = {:id=>data.first["arrangement_id"],  :number=>data.first["arrangement_number"], :name=>data.first["arrangement_name"], :organ=>data.first["organ_name"]}

        data.each do |d|
          if current_arr[:id] != d["arrangement_id"]
            #Set whole arr to nil if id was nil
            current_arr = nil if current_arr[:id].nil?
            report.arrangement_reports << ArrangementReport.generate(current_arr, current_data)
            current_data = [d]
            current_arr = {:id=>d["arrangement_id"], :number=>d["arrangement_number"], :name=>d["arrangement_name"], :organ=>d["organ_name"] }
          else
            current_data << d
          end
        end
        report.arrangement_reports << ArrangementReport.generate(current_arr, current_data)

        report.calculate_balance_difference

        report
      end

      def calculate_balance_difference 
        @balance_difference = arrangement_reports.reduce(0) { |memo, row| memo + row.balance_difference }
      end
    end
  end
end
