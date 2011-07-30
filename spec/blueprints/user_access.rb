UserAccess.blueprint do
  user          { User.make }
  serie         { Serie.make }
  granted_by    { User.make }
end
