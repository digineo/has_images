# HasImages

module HasImages
  def self.included(base)
    base.send :extend, ClassMethods    
  end

  module ClassMethods
    # adds has_images to model
    def has_images(options={})
      counter_cache = options.delete(:couter_cache) || false
      # eval is not always evil ;)
      # we generate a Digineo::Model::Image clase to store the given paperclip configuration in it  
      eval <<-EOF
        module Digineo::#{self.class_name} 
          class Digineo::#{self.class_name}::Image < Digineo::Image
             has_attached_file :file, #{options.inspect}
             belongs_to :parentmodel, :polymorphic => true, :counter_cache => #{counter_cache.inspect}
          end
        end
      EOF
      
      has_many :images, :as => :parentmodel, :dependent => :destroy, :order => 'id ASC', :class_name => "Digineo::#{self.class_name}::Image"
      has_one  :avatar, :as => :parentmodel, :conditions => 'avatar=1', :class_name => "Digineo::#{self.class_name}::Image"      
      has_many :galleries, :as => :parentmodel, :dependent => :destroy, :class_name => 'Digineo::ImageGallery'            
      
      named_scope :with_avatar, :include => :avatar
      
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
