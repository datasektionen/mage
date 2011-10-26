UserAccess.blueprint do
  user          { User.make }
  serie         { Series.make }
  granted_by    { User.make }
end
