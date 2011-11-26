AccountGroup.blueprint do 
  title { "AccountGroup#{sn}" }
  activity_year { ActivityYear.first }
  account_type { (3..4).to_a.sample }
end
