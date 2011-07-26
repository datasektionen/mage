User.blueprint do
  ugid          { "u1%06d" % sn.to_i }
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
