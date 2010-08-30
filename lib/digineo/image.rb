class Digineo::Image < ActiveRecord::Base
  
  set_table_name :digineo_images
  store_full_sti_class = true  
  
  belongs_to :parentmodel, :polymorphic => true
  belongs_to :gallery,    :class_name => "Digineo::ImageGallery"
  belongs_to :image_type, :class_name => "Digineo::ImageType"  
  attr_accessor :file_url
  attr_accessor :gallery_name
  attr_accessor :image_type_name
  
  before_create :should_be_avatar?
  before_destroy :unset_avatar if :avatar
  
  named_scope :not_avatar, :conditions => "avatar=0"
  named_scope :without_gallery, :conditions => "gallery_id IS NULL"
  
  
  named_scope :image_type, lambda { |*types|
    { :conditions => "image_type_id IN (" + types.collect do |type|
        begin
          type.is_a?(Integer) ? type : Digineo::ImageType.find_by_name(type).id 
        rescue 
          raise Digineo::ImageType::Exception, "Could not find ImageType with name #{type}"
        end
        end.compact.join(",") + ")"}
    }
    
    has_attached_file :file
    
    after_save :set_gallery, :set_image_type
    
    
    validates_attachment_presence :file, :unless => :file_url_provided?, :on => :create
    validates_presence_of :parentmodel
    before_validation :download_remote_file, :if => :file_url_provided?
    
    validates_presence_of :file_remote_url, :if => :file_url_provided?, :message => 'is invalid or inaccessible'
    
    # sets the avatar flag on this image
    def set_avatar
      parentmodel.avatar.unset_avatar if parentmodel.avatar
      update_attribute(:avatar, true)
    end
    
    # removes avatar flag
    def unset_avatar
      update_attribute(:avatar, false)
    end
    
    def set_gallery    
      return if gallery_id or gallery_name.to_s.empty?
      self.gallery_id = parentmodel.find_or_create_gallery(gallery_name).id
      save
    end
    
    def set_image_type    
      return if image_type_id or image_type_name.to_s.empty?
      self.image_type_id = ImageType.find_or_create_by_name(image_type_name).id
      save
    end
    
    private
    
    def should_be_avatar?
      self.avatar = !parentmodel.avatar
      true # returns true because it's called by before_create
    end
    
    def file_url_provided?
      !self.file_url.blank?
    end
    
    def download_remote_file
      self.file = do_download_remote_file
      self.file_remote_url = file_url
    end
    
    def do_download_remote_file
      io = open(URI.parse(file_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
    rescue # TODO catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
    end
    
  end
