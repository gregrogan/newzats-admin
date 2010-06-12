# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_newzatsadmin_session',
  :secret      => 'a4c1f1cfdcc579a86735ae0a4c9d2d727b12fa133ac381d02431b3838f7dee948ccf8800fedaf9b3c14f3bfd124057e6c29f727dd1f9a864d7e29d403407bd13'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
