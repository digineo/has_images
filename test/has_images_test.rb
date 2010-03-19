require File.dirname(__FILE__) + '/test_helper'

class User < ActiveRecord::Base
  has_images
end

class HasImagesTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
