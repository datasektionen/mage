User.blueprint do
  ugid          { "u1%06d" % sn }
  login         { "user-#{sn}" }
  first_name    { "User" }
  last_name     { "#{sn}" }
  email         { "user-#{sn}@example.org" }
  default_serie { Serie.make }
  initials      { "U#{sn}" }
end

User.blueprint :admin do
  admin { true }
end
