require 'test_helper'

class Digineo::ImageTest < ActiveSupport::TestCase
  
  should_belong_to :parentmodel, :gallery, :image_type
  should_have_friendly_name
end
