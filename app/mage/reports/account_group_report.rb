module Mage
  module Reports
    class AccountGroupReport
      attr_reader :account_group, :account_reports
      attr_reader :balance_difference, :total_debet, :total_kredit

      def initialize(account_group) 
        @account_group = account_group
        @account_reports = []
      end

      def self.generate(account_group, data)
        report = new(account_group)

        current_data = []
        current_account = {:number=>data.first["account_number"], :name=>data.first["account_name"], :ingoing_balance=>data.first["ingoing_balance"]}
        
        data.each do |d|
          if current_account[:number] != d["account_number"]
            current_account = nil if current_account[:number].nil?
            report.account_reports << AccountReport.generate(current_account, current_data)
            current_data = [d]
            current_account = {:number=>d["account_number"], :name=>d["account_name"], :ingoing_balance=>d["ingoing_balance"]}
          else
            current_data << d
          end
        end
        report.account_reports << AccountReport.generate(current_account, current_data)

        report.calculate_balance_difference

        report
      end

      def calculate_balance_difference 
        @balance_difference = 0
        @total_debet = 0
        @total_kredit = 0
        account_reports.each do |report|
          @balance_difference+=report.balance_difference
          @total_debet += report.total_debet
          @total_kredit += report.total_kredit
        end
      end
    end
  end
end
