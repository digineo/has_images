class HasImagesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'db/migrate/create_has_images.rb', "db/migrate", { :migration_file_name => "create_has_images"  } 
    end
  end
end
