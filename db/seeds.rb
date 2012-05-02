# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#

ay = ActivityYear.find_or_create_by_year(year: Time.now.year)

unless Organ.any?
  Organ.create([
    {:name=>'Mottagningen'},
    {:name=>'DKM'},
    {:name=>'Centralt'},
    {:name=>'ESCapo'},
    {:name=>'QN'}
  ])
end

unless Series.any?
  Series.create([
    {name: 'Centralt', letter: 'C'},
    {name: 'Mottagningen', letter: 'M', default_organ: Organ.find_by_name('Mottagningen')},
    {name: 'DKM', letter: 'K', default_organ: Organ.find_by_name('DKM')}
  ])
end
