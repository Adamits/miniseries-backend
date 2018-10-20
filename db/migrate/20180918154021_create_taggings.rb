class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :user_id
      t.integer :start
      t.integer :end
      t.text :content
      t.integer :tagable_id
      t.string :tagable_type
      t.timestamps
    end

    add_index :taggings, :tag_id
    add_index :taggings, :tagable_id
    add_index :taggings, :tagable_type
    add_index :taggings, :user_id
  end
end
