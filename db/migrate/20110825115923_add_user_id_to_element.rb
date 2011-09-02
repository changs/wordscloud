class AddUserIdToUser < ActiveRecord::Migration
  def change
    add_column :elements, :user_id, :integer
  end
end
