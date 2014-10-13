module Mage
  module Reports
    class ArrangementReport
      attr_reader :arrangement, :account_group_reports
      attr_reader :balance_difference, :total_debet, :total_kredit

      def initialize(arrangement)
        @arrangement = arrangement
        @account_group_reports = []
      end

      def self.generate(arrangement, data)
        report = new(arrangement)

        current_data = []
        current_account_group = {:number=>data.first["account_group_number"], :name=>data.first["account_group_name"]}

        data.each do |d|
          if current_account_group[:number] != d["account_group_number"]
            current_account_group = nil if current_account_group[:number].nil?
            report.account_group_reports << AccountGroupReport.generate(current_account_group, current_data)
            current_data = [d]
            current_account_group = {:number=>d["account_group_number"], :name=>d["account_group_name"]}
          else
            current_data << d
          end
        end
        report.account_group_reports << AccountGroupReport.generate(current_account_group, current_data)

        report.calculate_balance_difference

        report
      end

      def calculate_balance_difference
        @balance_difference = 0
        @total_debet = 0
        @total_kredit = 0
        account_group_reports.each do |report|
          @balance_difference+=report.balance_difference
          @total_debet += report.total_debet
          @total_kredit += report.total_kredit
        end
      end
    end
  end
end
