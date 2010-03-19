Gem::Specification.new do |s|
  s.name = %q{has_images}
  s.version = "0.1.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors     = ["Dennis Meise"]
  s.date        = %q{2010-03-19}
  s.summary     = %q{HasImages adds images and galleries to your ActiveRecord models.}
  s.homepage = %q{http://github.com/digineo/has_images}
  s.email       = %q{github@digineo.de}
  s.extra_rdoc_files = ["README.md"]
  s.files = %w(
    generators/has_images/has_images_generator.rb
    generators/has_images/USAGE
    generators/has_images/templates/db/migrate/create_has_images.rb
    init.rb
    Rakefile
    README.md
    lib/has_images.rb
    lib/digineo.rb
    lib/digineo/image_gallery.rb
    lib/digineo/image_type.rb
    lib/digineo/image.rb
    rails/init.rb
  )
  s.has_rdoc         = true
  s.rdoc_options     = ["--inline-source", "--charset=UTF-8"]
  s.require_paths    = ["lib"]
  s.rubygems_version = '1.3.0'
  s.add_dependency("paperclip", [">= 2.3"])
  s.test_files =%w(
  	 test/unit/digineo/image_gallery_test.rb
  	 test/unit/digineo/image_type_test.rb
  	 test/unit/digineo/image_test.rb
     test/has_images_test.rb
     test/test_helper.rb
  )
end