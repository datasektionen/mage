# encoding: utf-8

require "sie"

# Exports activity years to SIE.
class SieExporter
  def initialize(activity_year)
    @activity_year = activity_year
  end

  def call
    Sie::Document.new(self).render
  end

  def program
    "MAGE"
  end

  def program_version
    `git rev-parse --short HEAD`.chomp
  end

  def generated_on
    Date.today
  end

  def financial_years
    [activity_year.starts..activity_year.ends]
  end

  def company_name
    "Konglig Datasektionen"
  end

  def accounts
    activity_year.accounts.map do |account|
      { number: account.number, description: account.name }
    end
  end

  def balance_account_numbers
    activity_year.accounts.where("number < ?", 3000).pluck(:number)
  end

  def closing_account_numbers
    activity_year.accounts.where("number >= ?", 3000).pluck(:number)
  end

  def balance_before(account_number, date)
    ingoing_balance = activity_year.
      accounts.
      where(number: account_number).
      first!.
      ingoing_balance
    result = VoucherRow.
      joins(:voucher).
      where("vouchers.activity_year_id" => activity_year.id).
      where("vouchers.accounting_date <= ?", date).
      where(canceled: false).
      sum(:sum)
    ingoing_balance + result
  end

  # Used to load voucher data in batches so that you don't need to load all of
  # it into memory at once.
  def each_voucher(&block)
    activity_year.vouchers.map { |voucher| voucher_sie_hash(voucher) }.
      each(&block)
  end

  def dimensions
    [
      {
        number: 1,
        description: "Nämnd",
        objects: Organ.all.map do |organ|
          { number: organ.id, description: organ.name }
        end
      },
      {
        number: 2,
        description: "Arrangemang",
        objects: Arrangement.in_year(activity_year.year).map do |arrangement|
          { number: arrangement.id, description: arrangement.name }
        end
      }
    ]
  end

  private

  attr_reader :activity_year

  def voucher_sie_hash(voucher)
    {
      series: voucher.series.letter,
      number: voucher.number,
      booked_on: voucher.accounting_date.to_date,
      description: voucher.title,
      voucher_lines: voucher.voucher_rows.map do |voucher_row|
        voucher_row_sie_hash(voucher_row)
      end
    }
  end

  def voucher_row_sie_hash(voucher_row)
    {
      account_number: voucher_row.account_number,
      amount: voucher_row.sum,
      booked_on: voucher_row.updated_at.to_date,
      description: voucher_row.signature.try(:initials) || "",
      dimensions: { 1 => voucher_row.voucher.organ_id }
    }.tap do |voucher_row_hash|
      if voucher_row.arrangement_id
        voucher_row_hash[:dimensions][2] = voucher_row.arrangement_id
      end
    end
  end
end
