Account.blueprint do
  number       { sn.to_i % 10000 }
  name         { "Account#{sn}" }
  account_group { AccountGroup.make }
  activity_year { ActivityYear.first }
end
