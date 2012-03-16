module Mage
  module Reports
    class AccountReport
      attr_reader :account, :voucher_rows, :balance_difference, :total_debet, :total_kredit
      attr_reader :ingoing_balance, :outgoing_balance

      def initialize(account, voucher_rows=[])
        @account = account
        @voucher_rows = voucher_rows
        @ingoing_balance = account[:ingoing_balance]
        raise "ingoing balance is nil for #{account.inspect}" if @ingoing_balance.nil?
      end

      def self.generate(account, voucher_rows=[])
        report = new(account, voucher_rows)
  
        report.calculate_outgoing_balance
 
        report
      end

      def calculate_outgoing_balance
        calculate_balance_difference
        @outgoing_balance = @ingoing_balance + @balance_difference
      end

      def calculate_balance_difference 
        @balance_difference = 0
        @total_debet = 0
        @total_kredit = 0
        voucher_rows.each do |row|
          @balance_difference+=row["sum"]
          row["debet"] = [0, row["sum"]].max
          row["kredit"] = [0, row["sum"]].min
          @total_debet += row["debet"]
          @total_kredit += row["kredit"]
          row["accumulated"] = @ingoing_balance + @balance_difference
        end
      end
    end
  end
end
