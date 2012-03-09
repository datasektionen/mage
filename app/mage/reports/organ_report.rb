module Mage
  module Reports
    class OrganReport
      attr_reader :organ, :balance_difference
      attr_accessor :arrangement_reports

      def initialize(organ)
        @organ = organ
        @arrangement_reports = []
      end

      ##
      # data: A hash with the data
      def self.generate(organ, data) 
        report = new(organ)
        

        report.calculate_balance_difference

        report
      end

      def calculate_balance_difference 
        @balance_difference = arrangement_reports.reduce(0) { |memo, row| memo + row.balance_difference }
      end
    end
  end
end
