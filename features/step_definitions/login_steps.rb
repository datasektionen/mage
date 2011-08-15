Given /^I am logged in$/ do
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:cas, {:uid => 'u1dhz6b0' })

  visit '/users/auth/cas'
  @user = User.find_by_ugid('u1dhz6b0')
end
