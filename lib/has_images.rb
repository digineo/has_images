# HasImages
module HasImages
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # adds has_images to model
    def has_images
      has_many :images, :as => :parentmodel, :dependent => :destroy, :order => 'id ASC', :class_name => "Digineo::Image"
      has_one  :avatar, :as => :parentmodel, :order => 'id ASC', :class_name => "Digineo::Image", :conditions => 'avatar=1'      
      has_many :galleries, :as => :parentmodel, :dependent => :destroy, :class_name => 'Digineo::ImageGallery'
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    def has_avatar?
      !avatar.nil?
    end
    
     ## gibt alle Bilder zurück die nicht avatar sind
    def more_pics
       images.not_avatar
    end
    
    def images_without_gallery
      images.without_gallery
    end
    
    def has_more_pics?
      images.not_avatar.size > 0
    end
    
    def has_gallery?
      galleries.size > 0
    end
    
    def create_image_by_url(url, image_type = nil)
      images.create!(:file_url => url, :image_type => image_type)
    end
  end
end
