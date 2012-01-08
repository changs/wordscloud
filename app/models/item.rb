# == Schema Information
#
# Table name: items
#
#  id         :integer         not null, primary key
#  question   :string(255)
#  answer     :string(255)
#  ef         :float
#  interval   :float
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  review_at  :datetime
#  public     :boolean
#

class Item < ActiveRecord::Base
  attr_accessible :question, :answer, :user, :public
  attr_accessor :grade

  belongs_to :user
  has_many :item_relationships, foreign_key: "parent_id", dependent: :destroy
  has_many :children, through: :item_relationships, source: :child
  has_many :reverse_item_relationships, foreign_key: "child_id", class_name: "ItemRelationship",
    dependent: :destroy
  has_many :parent, through: :reverse_item_relationships, source: :parent
  validates :question, presence: true
  validates :answer, presence: true

  before_create { set_default_attr }

  def self.next_review_for(user)
    user.items.where("review_at <= ?", Time.now.end_of_day ).order('RANDOM()').first
  end

  def update_ef(grade)
    self.ef = self.ef+(0.1-(5-grade)*(0.08+(5-grade)*0.02))   # Supermemo 2.0 Algorithm
    self.ef = 1.3 if self.ef < 1.3
    if self.interval <= 1 and grade >= 3
      self.interval = 3
    elsif (self.interval != 1 ) and (grade >= 3)
      self.interval = self.interval * self.ef
    else
      self.interval = 0
    end
    self.review_at = self.updated_at + (self.interval).days 
  end
  def set_default_attr
    self.ef = 2.2
    self.interval = 1
    self.review_at = (Time.now + 1.day)
  end

  def parent?(child)
    item_relationships.find_by_child_id(child)
  end

  def share(child)
    item_relationships.create!(child_id: child.id)
  end


  default_scope :order => 'items.created_at DESC'
  # Return microposts from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private

  # Return an SQL condition for users followed by the given user.
  # Include the user's own id as well.
  def self.followed_by(user)
    following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
                        where("user_id IN (#{following_ids})",
                              { :user_id => user })
  end

end
