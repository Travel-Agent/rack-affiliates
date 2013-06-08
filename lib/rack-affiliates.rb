require 'rack-affiliates/configuration'

module Rack
  #
  # Rack Middleware for extracting information from the request params and cookies.
  # It populates +env['affiliate.tag']+, # +env['affiliate.from']+ and
  # +env['affiliate.time'] if it detects a request came from an affiliated link 
  #
  class Affiliates
    class << self
      def configure(&block)
        yield(config)
        config
      end

      def config
        @configuration ||= Configuration.new
      end
    end

    def initialize(app)
      @app = app
      @config = Rack::Affiliates.config
    end

    def call(env)
      @req = Rack::Request.new(env)

      if !@config.skip_asset_file? or !asset_file?
        params_tag = @req.params[@config.param]
        cookie_tag = @req.cookies[@config.cookie_tag]

        if cookie_tag
          tag, from, time = cookie_info
        end

        if params_tag && params_tag != cookie_tag
          tag, from, time = params_info
        end

        if tag
          env['affiliate.tag']  = tag
          env['affiliate.from'] = from
          env['affiliate.time'] = time
        end
      end

      status, headers, body = @app.call(env)

      if tag != cookie_tag
        bake_cookies(headers, tag, from, time)
      end

      [status, headers, body]
    end

    def affiliate_info
      params_info || cookie_info
    end

    def params_info
      [@req.params[@config.param], @req.env["HTTP_REFERER"], Time.now.to_i]
    end

    def cookie_info
      cookies = @req.cookies
      [cookies[@config.cookie_tag], cookies[@config.cookie_from], cookies[@config.cookie_time].to_i] 
    end

    end

    protected
    def bake_cookies(headers, tag, from, time)
      expires = Time.now + @config.ttl
      { @config.cookie_tag => tag,
        @config.cookie_from => from,
        @config.cookie_time => time }.each do |key, value|
          cookie_hash = {:value => value, :expires => expires}
          cookie_hash[:domain] = @config.domain if @config.domain
          cookie_hash[:path]   = @config.path   if @config.path
          Rack::Utils.set_cookie_header!(headers, key, cookie_hash)
      end
    end

    private
    def asset_file?
      file_ext = ::File.extname(@req.path_info)
      mime_type = Rack::Mime.mime_type(file_ext, 'text/html')

      mime_type.eql?('text/css') || mime_type =~ /^(image|application)\//
    end
  end
end