# Include hook code here
require 'open-uri'
require 'has_images'
ActiveRecord::Base.send(:include, HasImages)

Paperclip.interpolates :short_id_partition do |attachment, style| 
  ("%08d" % attachment.instance.id).scan(/\d{4}/).join("/")
end

Paperclip.interpolates :parent do |attachment, style| 
  attachment.instance.parentmodel.image_folder rescue attachment.instance.parentmodel.class.to_s.underscore.pluralize
end

Paperclip.interpolates :parent_name do |attachment, style| 
  attachment.instance.parentmodel.seo_name rescue attachment.instance.parentmodel.to_s
end