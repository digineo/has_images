class Digineo::ImageGallery < ActiveRecord::Base
  
  set_table_name :digineo_image_galleries
  
  belongs_to :parentmodel, :polymorphic => true
  has_many :images, :class_name => 'Digineo::Image', :foreign_key => :gallery_id
  
  validates_presence_of :name
  
end
