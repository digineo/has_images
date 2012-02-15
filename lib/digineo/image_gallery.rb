class Digineo::ImageGallery < ActiveRecord::Base

  self.table_name = :digineo_image_galleries

  belongs_to :parentmodel, :polymorphic => true
  has_many :images, :class_name => 'Digineo::Image', :foreign_key => :gallery_id
  has_one  :avatar, :foreign_key => :gallery_id, :class_name => "Digineo::Image"

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:parentmodel_id, :parentmodel_type]

  def create_image_by_url(url, image_type = nil)
    images.create!(:file_url => url, :parentmodel => parentmodel, :image_type => image_type)
  end

end
