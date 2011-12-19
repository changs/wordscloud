# == Schema Information
#
# Table name: item_relationships
#
#  id         :integer         not null, primary key
#  parent_id  :integer
#  child_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class ItemRelationship < ActiveRecord::Base
  attr_accessible :child_id

  belongs_to :parent, class_name: "Item"
  belongs_to :child, class_name: "Item"
end
