Arrangement.blueprint do
  name { "Arrangement#{sn}" }
  organ  { Organ.make }
  number { sn % 1000 }
end
