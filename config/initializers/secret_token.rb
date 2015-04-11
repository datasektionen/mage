# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Mage::Application.config.secret_token = ENV["SECRET_TOKEN"] ||
  '5e4df1c89841e21fa8e9114c5dc73b264f9fc36e24e15162e727bf0e2d9ce2c84d8e315bdec3f5e1439c13fa0b08e5e218e8f2fbf3f12898b769975b1dcfa4cf'
