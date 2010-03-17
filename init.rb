# Include hook code here
require 'has_images'
ActiveRecord::Base.send(:include, HasImages)

Paperclip.interpolates :appname do |attachment, style| 
  ("%08d" % attachment.instance.id).scan(/\d{4}/).join("/")
end

Paperclip.interpolates :appname do |attachment, style| 
  attachment.instance.parentmodel.image_folder rescue attachment.instance.parentmodel.class.to_s.underscore.pluralize
end

Paperclip.interpolates :appname do |attachment, style| 
  attachment.instance.parentmodel.seo_name
end