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
      t.string :name
      t.text   :text
      t.integer :gallery_id, :on_delete => :set_null, :references => :digineo_image_galleries
      t.integer :image_type_id, :on_delete => :set_null, :references => :digineo_image_types
      t.integer :parentmodel_id, :references => nil
      t.integer :user_id, :references => nil
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
    add_index(:digineo_image_galleries, [:parentmodel_id, :parentmodel_type])
    add_index(:digineo_images, [:parentmodel_id, :parentmodel_type, :type], :name => 'parentmodel_type')
    add_index(:digineo_images, [:parentmodel_id, :parentmodel_type, :type, :avatar], :name => 'parentmodel_type_avatar')
  end

  def self.down
    drop_table :digineo_images
    drop_table :digineo_image_galleries
    drop_table :digineo_image_types
  end
end
