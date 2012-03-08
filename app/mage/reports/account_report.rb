module Mage
  module Reports
    class AccountReport
      attr_reader :account, :voucher_rows, :balance_difference
      attr_reader :ingoing_balance, :outgoing_balance

      def initialize(account, voucher_rows=[])
        @account = account
        @voucher_rows = voucher_rows
        @ingoing_balance = account[:ingoing_balance]
      end

      def self.generate(account, voucher_rows=[])
        report = new(account, voucher_rows)
  
        #report.calculate_outgoing_balance
 
        report
      end

      def calculate_outgoing_balance
        calculate_balance_difference
        @outgoing_balance = @ingoing_balance + @balance_difference
      end

      def calculate_balance_difference 
        @balance_difference = voucher_rows.reduce(0) { |memo, row| memo + row[:sum] }
      end
    end
  end
end
