require 'rails/railtie'

module HasImages
  class Railtie < Rails::Railtie

    initializer "has_images.active_record" do |app|
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send(:include, HasImages)
      end
    end

  end
end
