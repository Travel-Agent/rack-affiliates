Rack::Affiliates.configure do |config|
  #
  # Pass a block with a tag parameter to perform tag validation before accepting a tag
  #
  # Example:
  # Check that an `Affiliate` exists with that code
  #
  #config.valid_tag do |tag|
  #  Affiliate.find_by_code(tag).present?
  #end

  #
  # Change query parameter to use
  # Default: 'ref'
  #config.param = 'aff_id'

  # Change TTL (Time To Live) for a cookie
  # Default: 1 month (60*60*24*30)
  #config.ttl = 1.month.to_i

  # Change domain of the cookie
  # Default: nil
  #
  # Example: Set different domain according to Rails.env
  #
  #config.domain = if Rails.env.production?
  #  '.example.com'
  #else
  #  '.example.local'
  #end

  # Change path of the cookie
  # Default: '/'
  #
  # Example: set to nil for current path
  #
  #config.path = nil

  # Change the cookies prefix
  # Default: 'aff'
  #
  # Example: set cookies to be my_tag, my_from, my_time
  #config.cookie_prefix = 'my'

  # You can disable skipping asset files (not recommended, especially if you use valid_tag to access the DB)
  #config.skip_asset_files = false
end