class AddToReviewToElement < ActiveRecord::Migration
  def change
    add_column :elements, :to_review, :timestamp
  end
end
