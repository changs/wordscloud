class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :question
      t.string :answer
      t.float :ef
      t.float :interval

      t.timestamps
    end
  end
end
