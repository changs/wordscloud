class ItemRelationship < ActiveRecord::Base
  attr_accessible :child_id

  belongs_to :parent, class_name: "Item"
  belongs_to :child, class_name: "Item"
end
