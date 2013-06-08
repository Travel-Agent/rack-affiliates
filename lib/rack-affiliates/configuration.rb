module Rack
  class Affiliates
    class Configuration
      attr_accessor :ttl
      attr_accessor :param
      attr_accessor :domain
      attr_accessor :path
      attr_accessor :cookie_prefix

      def initialize
        @ttl           = 1.month.to_i
        @param         = 'ref'
        @domain        = nil
        @path          = '/'
        @cookie_prefix = 'aff'
      end

      def cookie_tag
        @cookie_prefix + '_tag'
      end

      def cookie_from
        @cookie_prefix + '_from'
      end

      def cookie_time
        @cookie_prefix + '_time'
      end

      def valid_tag(&block)
        @valid_tag = block if block_given?
        @valid_tag
      end
    end
  end
end