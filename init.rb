# Include hook code here
require 'open-uri'
require 'has_images'
ActiveRecord::Base.send(:include, HasImages)
