require File.dirname(__FILE__) + '/../../test_helper'

class Digineo::ImageTypeTest < ActiveSupport::TestCase
  should_validate_presence_of :name
  should_have_many :images
end
