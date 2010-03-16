class CreateHasImages < ActiveRecord::Migration
  def self.up
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
      t.string :name, :null => false
      t.text   :text
      t.integer :gallery_id, :on_delete => :set_null, :references => :digineo_image_galleries
      t.integer :image_type_id, :on_delete => :set_null, :references => :digineo_image_types
      t.integer :parentmodel_id, :references => nil
      t.string  :parentmodel_type
      t.string :friendly_name, :null => false
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.string :type
      t.boolean :avatar, :default => false, :null => false
      t.timestamps
    end
    add_index(:digineo_images, :friendly_name, :unique => true)
  end

  def self.down
    drop_table :digineo_images
    drop_table :digineo_image_galleries
    drop_table :digineo_image_types
  end
end
