require 'open-uri'
require 'paperclip'
require 'digineo'

# HasImages

module HasImages

  autoload :Scope, 'has_images/scope'

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # adds has_images to model
    def has_images(options={})
      counter_cache = options.delete(:counter_cache) || false
      options.merge! :use_timestamp => false
      # eval is not always evil ;)
      # we generate a Digineo::Model::Image clase to store the given paperclip configuration in it
      ::Digineo::Image.const_set(self.name, Class.new(Digineo::Image::Base){
             has_attached_file :file, options
             belongs_to :parentmodel, :polymorphic => true, :counter_cache => counter_cache
      })

      belongs_to :parentmodel, :polymorphic => true, :counter_cache => counter_cache
      has_many :images, -> { order('id ASC') }, :as => :parentmodel, :dependent => :destroy, :class_name => "Digineo::Image::#{self.name}"
      has_one  :avatar, -> { where(avatar: 1) }, :as => :parentmodel, :dependent => :destroy, :class_name => "Digineo::Image::#{self.name}"
      has_many :galleries, :as => :parentmodel, :dependent => :destroy, :class_name => 'Digineo::ImageGallery'

      after_create :save_avatar

      self.extend HasImages::Scope

      scope_method :with_avatar, -> { includes(:avatar) }

      send :include, InstanceMethods

      alias_method_chain :avatar=, :autobuild

    end

    def digineo_image_class
      ::Digineo::Image.const_get(self.name)
    end
  end

  module InstanceMethods

    # returns all images that are not set as avatar
    def more_images
       images.not_avatar
    end

    # returns all images without gallery
    def images_without_gallery
      images.without_gallery
    end

    # does this model have any images,  that are not set as avatar?
    def has_more_images?
      images.not_avatar.any?
    end

    def galleries?
      galleries.any?
    end

    def find_or_create_gallery(name)
      galleries.find_or_create_by_name(name)
    end

    def create_image_by_url(url, image_type = nil)
      images.create!(:file_url => url, :image_type => image_type)
    end

    def avatar_with_autobuild=(image_or_upload)
      if image_or_upload.kind_of? Digineo::Image::Base
        super
      else
        avatar.update_attribute :avatar, 0 if avatar
        abo = { :file => image_or_upload, :avatar => 1 }
        if respond_to? :avatar_build_opts
          abo.merge! avatar_build_opts
        end
        Rails.logger.debug abo.inspect
        avatar = build_avatar abo
        if persisted?
          avatar.save!
        else
          @avatar = avatar
        end
      end
    end

    def save_avatar
      if @avatar
        @avatar.attributes = avatar_build_opts if respond_to? :avatar_build_opts
        @avatar.save!
        @avatar = nil
      end
    end

  end
end

require "has_images/railtie" if defined?(Rails) && Rails.version >= "3"


