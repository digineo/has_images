# HasImages

module HasImages
  def self.included(base)
    base.send :extend, ClassMethods    
  end

  module ClassMethods
    # adds has_images to model
    def has_images(options={})
      # setting options in image model for the current class
      #Digineo::Image.has_images_options[self.table_name.to_sym].merge(options)
      has_many :images, :as => :parentmodel, :dependent => :destroy, :order => 'id ASC', :class_name => "Digineo::Image"
      has_one  :avatar, :as => :parentmodel, :order => 'id ASC', :class_name => "Digineo::Image", :conditions => 'avatar=1'      
      has_many :galleries, :as => :parentmodel, :dependent => :destroy, :class_name => 'Digineo::ImageGallery'            
      
      #named_scope :with_avatar, :include => :avatar
      
      send :include, InstanceMethods
    end
    
    
  end

  module InstanceMethods
    
     ## gibt alle Bilder zurück die nicht avatar sind
    def more_images
       images.not_avatar
    end
    
    def images_without_gallery
      images.without_gallery
    end
    
    def has_more_images?
      images.not_avatar.any?
    end
    
    def galleries?
      galleries.any?
    end
    
    def create_image_by_url(url, image_type = nil)
      images.create!(:file_url => url, :image_type => image_type)
    end
  end
end
