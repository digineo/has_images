class Digineo::Image < ActiveRecord::Base
  
  set_table_name :digineo_images
  store_full_sti_class = true  
  
  belongs_to :parentmodel, :polymorphic => true
  belongs_to :gallery,    :class_name => "Digineo::ImageGallery"
  belongs_to :image_type, :class_name => "Digineo::ImageType"  
  attr_accessor :file_url
  attr_accessor :gallery_name

  before_create :should_be_avatar?
  before_destroy :unset_avatar if :avatar
  
  named_scope :not_avatar, :conditions => "avatar=0"
  named_scope :without_gallery, :conditions => "gallery_id IS NULL"
  
  has_attached_file :file
  
  after_save :set_gallery
  
  
  validates_attachment_presence :file, :unless => :file_url_provided?, :on => :create
  validates_presence_of :parentmodel
  before_validation :download_remote_file, :if => :file_url_provided?
 
  validates_presence_of :file_remote_url, :if => :file_url_provided?, :message => 'is invalid or inaccessible'
  
  def set_avatar
    parentmodel.avatar.unset_avatar if parentmodel.avatar
    update_attribute(:avatar, true)
  end
  
  def unset_avatar
    update_attribute(:avatar, false)
  end
  
  def set_gallery    
    return if gallery_id or gallery_name.to_s.empty?
    self.gallery_id = parentmodel.find_or_create_gallery(gallery_name).id
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
    rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
  
end
