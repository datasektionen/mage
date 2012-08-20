Account.blueprint do
  number       { sn.to_i % 10000 }
  name         { "Account#{sn}" }
  account_group
  activity_year { ActivityYear.first }
end

Account.blueprint :type_1 do 
  account_group { AccountGroup.make(:account_type => 1 ) }
end

Account.blueprint :type_2 do 
  account_group { AccountGroup.make(:account_type => 2 ) }
end
