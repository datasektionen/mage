Series.blueprint do
  name          { "Series#{sn}" }
  letter        { ('A'..'Z').to_a.sample }
  default_organ { Organ.make }
end
