UserAccess.blueprint do
  user          { User.make }
  series         { Series.make }
  granted_by    { User.make }
end
