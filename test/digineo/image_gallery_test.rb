require 'test_helper'

class Digineo::ImageGalleryTest < ActiveSupport::TestCase
  should_validate_presence_of :name
  should_belong_to :parentmodel
  should_have_many :images
  should_validate_uniqueness_of :name, :scoped_to => [:parentmodel_id, :parentmodel_type]
end
