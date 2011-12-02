class CreateItemRelationships < ActiveRecord::Migration
  def change
    create_table :item_relationships do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
    add_index :item_relationships, :parent_id
    add_index :item_relationships, :child_id
    add_index :item_relationships, [:parent_id, :child_id], unique: true
  end
end
