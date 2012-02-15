class Digineo::ImageType < ActiveRecord::Base
  self.table_name = :digineo_image_types

  has_many :images, :class_name => "Digineo::Image"

  validates_presence_of :name
  validates_uniqueness_of :name

end

class Digineo::ImageType::Exception < Exception

end
