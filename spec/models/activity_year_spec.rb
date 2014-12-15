require 'spec_helper'

describe ActivityYear do
  it 'start should be correct' do
    activity_year = ActivityYear.make
    activity_year.starts.should == DateTime.new(activity_year.year, 1, 1)
  end

  it 'end should be correct' do
    activity_year = ActivityYear.make
    activity_year.ends.should == DateTime.new(activity_year.year, 12, 31)
  end

  it 'find_by_date should return correct activity year' do
    activity_year = ActivityYear.make
    activity_year.save
    ActivityYear.find_by_date(activity_year.starts).year.should == activity_year.year
    ActivityYear.find_by_date(activity_year.ends).year.should == activity_year.year
  end
end
