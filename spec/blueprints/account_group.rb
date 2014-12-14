AccountGroup.blueprint do
  title { "AccountGroup#{sn}" }
  account_type { (3..4).to_a.sample }
  number { sn.to_i % 10_000 }
end
