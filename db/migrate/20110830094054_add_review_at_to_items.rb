class AddReviewAtToItems < ActiveRecord::Migration
  def change
    add_column :items, :review_at, :timestamp
  end
end
