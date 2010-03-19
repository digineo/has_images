require File.dirname(__FILE__) + '/test_helper'

class User < ActiveRecord::Base
  has_images :styles => {
     :thumb  => ["150x100", :jpg],
     :mini   => ["75x50",   :jpg],
     :medium => ["300x200", :jpg],
     :large  => ["640x480", :jpg],
     :huge   => ["800x600", :jpg],
     :square => ["200x200", :jpg] }, 
     :path   => ":rails_root/public/images/:parent/:short_id_partition/:parent_name_:style.:extension",
     :url    => "/images/:parent/:short_id_partition/:parent_name_:style.:extension"
end

class UserTest < ActiveSupport::TestCase
  context "user model" do
    should_have_many :images, :galleries
    should_have_named_scope :with_avatar
    
    
    context "image configuration" do
      should "exist class Digineo::User::Image" do
        user = User.new
        
        assert Digineo::User::Image
        
        
      end      
    end
  end  
end

class HasImagesTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
