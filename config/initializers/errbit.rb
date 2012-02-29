Airbrake.configure do |config|
  config.api_key     = 'f37e922cee074ff2a6a7849581e78413'
  config.host        = 'errbit.datasektionen.se'
  config.port        = 80
  config.secure      = config.port == 443
end
