require 'rubygems'
require 'active_record'
require 'shoulda/rails'
require 'active_support/test_case'
require 'paperclip'

require File.expand_path(File.dirname(__FILE__)+"/../lib/digineo")
require File.expand_path(File.dirname(__FILE__)+"/../lib/digineo/image")
require File.expand_path(File.dirname(__FILE__)+"/../lib/digineo/image_gallery")
require File.expand_path(File.dirname(__FILE__)+"/../lib/digineo/image_type")
require File.expand_path(File.dirname(__FILE__)+"/../lib/has_images")
ActiveRecord::Base.send(:include, HasImages)

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])

ActiveRecord::Schema.define do
  create_table "users", :force => true do |t|
    t.column "name",  :text
    t.column "email", :text
  end
  
  create_table :digineo_image_types do |t|
    t.string  :name      
  end
  
  create_table :digineo_image_galleries do |t|
    t.string :name
    t.integer :parentmodel_id, :references => nil
    t.string  :parentmodel_type
    t.timestamps
  end  
  
  create_table :digineo_images do |t|
    t.string :name
    t.text   :text
    t.integer :gallery_id, :on_delete => :set_null, :references => :digineo_image_galleries
    t.integer :image_type_id, :on_delete => :set_null, :references => :digineo_image_types
    t.integer :parentmodel_id, :references => nil
    t.string  :parentmodel_type
    t.string :file_file_name
    t.string :file_content_type
    t.string :file_remote_url
    t.integer :file_file_size
    t.datetime :file_updated_at
    t.string :type
    t.boolean :avatar, :default => false, :null => false
    t.timestamps
  end
end

