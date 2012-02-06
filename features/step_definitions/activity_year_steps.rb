Given /^an activity year (\d+) with vouchers$/ do |year|
  @activity_year = ActivityYear.find_or_create_by_year(year)
  3.times do
    Voucher.make :activity_year => @activity_year
  end
end

Given /^the current activity year is (\d+)$/ do |year|
  @activity_year = ActivityYear.find_or_create_by_year(year)
  stub(:current_activity_year).and_return(@activity_year)
end
