# Include hook code here
require 'has_images'
ActiveRecord::Base.send(:include, HasImages)

Paperclip::Attachment.interpolations[:short_id_partition] = proc do |attachment, style|
  ("%08d" % attachment.instance.id).scan(/\d{4}/).join("/")
end

Paperclip::Attachment.interpolations[:parent] = proc do |attachment, style|
  attachment.instance.parentmodel.image_folder rescue attachment.instance.parentmodel.class.to_s.underscore.pluralize
end

Paperclip::Attachment.interpolations[:parent_name] = proc do |attachment, style|
  attachment.instance.parentmodel.seo_name
end