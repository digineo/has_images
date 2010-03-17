Digineo HasImages gem
=========

## Description
  HasImages adds images and galleries to your ActiveRecord models.
  It comes with the follwing mehtods:

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
  
## Examples & usage

### Create image by URL
    
    image = user.create_image_by_url("http://image.url/file.png")

### Images with galleries
    
    gallery = user.galleries.create(:name => "gallery name")
    
    gallery.images.create(params[:image])
    gallery.create_image_by_url("http://image.url/file.png")
  
### Imageupload via form




Copyright (c) 2010 Dennis Meise [Digineo GmbH](http://www.digineo.de/ "Digineo GmbH") , released under the MIT license
