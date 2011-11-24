AccountGroup.blueprint do 
  title { "AccountGroup#{sn}" }
  activity_year { ActivityYear.make }
  account_type { (3..4).to_a.sample }
end
