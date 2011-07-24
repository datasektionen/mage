Serie.blueprint do
  name          { "Serie#{sn}" }
  letter        { ('A'..'Z').to_a.sample }
  default_organ { Organ.make }
end
