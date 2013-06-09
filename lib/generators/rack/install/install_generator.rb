module Rack
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root ::File.expand_path('../../../../templates', __FILE__)

      desc "Installs Rack::Affiliates configuration initializer"

      def install
        template "initializer.rb", "config/initializers/rack-affiliates.rb"
      end
    end
  end
end
