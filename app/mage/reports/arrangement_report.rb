module Mage
  module Reports
    class ArrangementReport
      attr_reader :arrangement, :account_reports
      attr_reader :balance_difference

      def initialize(arrangement) 
        @arrangement = arrangement
        @account_reports = []
      end

      def self.generate(arrangement, data)
        report = new(arrangement)

        current_data = []
        current_account = {:number=>data.first["accounts.number"], :ingoing_balance=>data.first["account.ingoing_balance"]}
        
        data.each do |d|
          if current_account[:number] != d["account"]
            current_account = nil if current_account[:number].nil?
            report.account_reports << AccountReport.generate(current_account, current_data)
            current_data = [d]
            current_account = {:number=>d["accounts.number"], :ingoing_balance=>d["account.ingoing_balance"]}
          else
            current_data << d
          end
        end
        report.account_reports << AccountReport.generate(current_account, current_data)
        #report.calculate_balance_difference

        report
      end

      def calculate_balance_difference 
        @balance_difference = account_reports.reduce(0) { |memo, report| memo + report.balance_difference }
      end
    end
  end
end
