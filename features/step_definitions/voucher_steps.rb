Given /^I fill out the event form with some data$/ do
  #fill_in("event_name", :with => "test-event")
  #fill_in("event_description", :with => "test-event #{@timestamp}")
  #fill_in("event_date", :with => 7.days.from_now.to_s)
  #fill_in("event_deadline", :with => 5.days.from_now.to_s)
  #fill_in("event_free_for_all_date", :with => 5.days.from_now.to_s)
end

Then /^a voucher should have been created$/ do
  @voucher = Voucher.last
  @voucher.should_not be_nil
  #@voucher.description.should == "test-event #{@timestamp}"
end
