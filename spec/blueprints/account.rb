Account.blueprint do
  number       { sn.to_i % 10000 }
  name         { "Account#{sn}" }
  account_type { (1..4).to_a.sample }
end
