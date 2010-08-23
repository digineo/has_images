Digineo HasImages gem
=========

## Description
  HasImages adds images and galleries to your ActiveRecord models.
  It comes with the follwing methods:

    model.images # returns a list of all images
    model.avatar # returns the image with the avatar flag e.g. the first image
    model.galleries? # does this model have a gallery?
    model.galleries # returns a list of the models image galleries
    gallery.images  # returns all images in a gallery
    image.set_avatar # sets the avatar flag on this image

## Dependencies
  This gem requires thoughtbot's [paperclip](http://github.com/thoughtbot/paperclip), this gem will be installed automatically.

## Installation:
add the following to your config/enviroment.rb

  config.gem "has_images"


## Generate migrations & migrate

    ./script/generate has_images
  
    rake db:migrate
  
## Integration in your model

    class User < ActiveRecord::Base  
      has_images
    end
    
  you can also customize the image-storage with paperclip options
  
    class User < ActiveRecord::Base  
      has_images :styles => {
       :thumb  => ["150x100", :jpg],
       :mini   => ["75x50",   :jpg],
       :medium => ["300x200", :jpg],
       :large  => ["640x480", :jpg],
       :huge   => ["800x600", :jpg],
       :square => ["200x200", :jpg] }, 
       :path   => ":rails_root/public/images/:attachment/:id_partition/:id_:style.:extension",
       :url    => "/images/:attachment/:id_partition/:id_:style.:extension"
    end
  
## Examples & usage

### Imageupload via form
  
  in your view (uses [formtastic](http://github.com/justinfrench/formtastic))
  
    -semantic_form_for @image, :html => { :multipart => true } do |f|
      -f.inputs do
        =f.input :gallery_id, :as => :select, :collection => parent.galleries.all(:order=>'name')
  	    =f.input :gallery_name
        =f.input :name
        =f.input :text  
        =f.file_field :file, :input_html => { :size => 22 }
      =f.buttons
  
  in your controller:
    
    class ImagesController
    
      def new 
        @image = User.first.images.new
      end
      
      def create
        .....
        @image = User.first.images.create(params[:image])
        
        .....
      end
    
    end  
  

### Create image by URL
  has_images supports an easy method to create images from URLs:
  
    user  = User.first
    image = user.create_image_by_url("http://image.url/file.png")
    
  Of course you can also create the image manually with more arguments
  
  	user = User.first
  	user.images.create(:file_url => "http://image.url/file.png", :name => "my image")

  


### enabling Counter-Cache

    class User < ActiveRecord::Base  
      has_images :styles => {
       :thumb  => ["150x100", :jpg]
      }, 
       :path   => ":rails_root/public/images/:attachment/:id_partition/:id_:style.:extension",
       :url    => "/images/:attachment/:id_partition/:id_:style.:extension",
       :counter_cache => "images_count"
    end
    
    This enables the counter_cache for the user-model. CounterCache is saved in the field "images_count"

## Galleries
  
  has_images also supports image galleries to group images
    
### Images with galleries
    
    gallery = user.galleries.create(:name => "gallery name")
    
    gallery.images.create(params[:image])
    gallery.create_image_by_url("http://image.url/file.png")
    
### Create image gallery on the fly
  
  You can also create image galleries on the fly with the attr_accessor gallery_name:
   
	user  = User.find(1)
    image = user.images.create(:name => 'my cool image', :file_url => "http://image.url/image.jpg", :gallery_name => "my images")

## Image Types

  Sometimes you also have to group your images by specific image types. For example you could use the types "logo", "screenshot" and "banner" 
  
###  creating image types:
  
  You can easily create ImageType like this:
  
    Digineo::ImageType.create(:name => 'logo')
    Digineo::ImageType.create(:name => 'screenshot')
    Digineo::ImageType.create(:name => 'banner')
    
  another possibility is to create image types on the fly like this
  
    user = User.first
    user.images.create(:name => 'my cool image', :file_url => "http://image.url/image.jpg", :image_type_name => 'logo')
  
  in this case the ImageType "logo" will eiter be created or the id of an existing ImageType will be set

###  finding images of a specific type

    user = User.first    
    logos = user.images.image_type('logo')
    
  invalid image types will raise an Digineo::ImageType::Exception
  
    user = User.first
    invalid = user.images.image_type('invalid image type') 
      => Digineo::ImageType::Exception: Could not find ImageType with name invalid image type
      

Copyright (c) 2010 Dennis Meise [Digineo GmbH](http://www.digineo.de/ "Digineo GmbH") , released under the MIT license

