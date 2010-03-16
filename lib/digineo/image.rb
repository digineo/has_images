require 'open-uri'
class Digineo::Image < ActiveRecord::Base
  
  set_table_name :digineo_images
  
  belongs_to :parentmodel, :polymorphic => true
  belongs_to :gallery,    :class_name => "Digineo::ImageGallery"
  belongs_to :image_type, :class_name => "Digineo::ImageType"
  has_friendly_name
  attr_accessor :file_url

  before_create :should_be_avatar?
  #before_destroy :check_was_avatar
  
  named_scope :not_avatar, :conditions => "avatar=0"
  named_scope :without_gallery, :conditions => "gallery_id IS NULL"
  
  has_attached_file :file, :styles => {
     :thumb => ["150x100", :jpg],
     :mini => ["75x50", :jpg],
     :medium => ["300x200", :jpg],
     :large => ["640x480", :jpg],
     :huge => ["800x600", :jpg],
     :square => ["200x200", :jpg] }, 
     :path => ":rails_root/public/images/:parent/:short_id_partition/:basename_:style.:extension",
     :url        => "/images/:parent/:short_id_partition/:basename_:style.:extension"

     
  validates_attachment_presence :file
  
  before_validation :download_remote_file, :if => :file_url_provided?
 
  validates_presence_of :file_remote_url, :if => :file_url_provided?, :message => 'is invalid or inaccessible'
  
  private
  
  def should_be_avatar?
    self.avatar = !parentmodel.avatar
    true
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
