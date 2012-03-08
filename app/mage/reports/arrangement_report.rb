module Mage
  module Reports
    class ArrangementReport
      attr_reader :arrangement, :account_reports
      attr_reader :balance_difference

      def initialize(arrangement) 
        @arrangement = arrangement
        @account_reports = account_reports
      end

      def self.generate(arrangement, data)
        report = new(arrangement)

        current_data = []
        current_account = {:account=>data.first["accounts.number"], :ingoing_balance=>data.first["account.ingoing_balance"]
        
        report.calculate_balance_difference

        report
      end

      def calculate_balance_difference 
        @balance_difference = account_reports.reduce(0) { |memo, report| memo + report.balance_difference }
      end
    end
  end
end
