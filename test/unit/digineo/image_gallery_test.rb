require File.dirname(__FILE__) + '/../../test_helper'

class Digineo::ImageGalleryTest < ActiveSupport::TestCase
  should_validate_presence_of :name
  should_belong_to :parentmodel
  should_have_many :images
end
