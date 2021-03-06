User.blueprint do
  ugid          { format('u1%06d', sn.to_i) }
  login         { "user-#{sn}" }
  first_name    { 'User' }
  last_name     { "#{sn}" }
  email         { "user-#{sn}@example.org" }
  default_series { Series.make }
  initials      { "U#{sn}" }
end

User.blueprint :admin do
  admin { true }
end
