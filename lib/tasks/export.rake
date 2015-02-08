# encoding: utf-8

namespace :export do
  desc "Export an activity year to SIE"
  task :sie, [:year] => :environment do |_t, args|
    year = args[:year] || Date.today.year
    activity_year = ActivityYear.where(year: year).first!
    puts SieExporter.new(activity_year).call
  end
end
