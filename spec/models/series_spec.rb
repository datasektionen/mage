require 'spec_helper'

describe Series do
  it 'should not require name and letter' do
    series = Series.make
    series.name = nil
    series.should_not be_valid
    series.letter = nil
    series.should_not be_valid
    series.name = 'derp'
    series.should_not be_valid
  end
end
