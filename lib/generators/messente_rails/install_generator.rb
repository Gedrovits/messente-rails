module MessenteRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      desc 'Copies messente.rb into config/initializers directory'

      def copy_initializer
        template 'messente.rb', File.join(Rails.root, 'config', 'initializers', 'messente.rb')
      end
    end
  end
end
