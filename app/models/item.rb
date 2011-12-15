class Item < ActiveRecord::Base
  attr_accessible :question, :answer, :user, :public
  attr_accessor :grade

  belongs_to :user
  has_many :item_relationships, foreign_key: "parent_id", dependent: :destroy
  has_many :children, through: :item_relationships, source: :child

  validates :question, presence: true
  validates :answer, presence: true

  before_create { set_default_attr }

  def self.next_review_at(user)
    user.items.where("review_at <= ?", Time.now.end_of_day ).order('RANDOM()').first
  end

  def update_ef(grade)
    ef = ef+(0.1-(5-grade)*(0.08+(5-grade)*0.02))   # Supermemo 2.0 Algorithm
    ef = 1.3 if ef < 1.3
    if interval <= 1 and grade >= 3
      interval = 3
    elsif (interval != 1 ) and (grade >= 3)
      interval = interval * ef
    else
      interval = 0
    end
    review_at = updated_at + (interval).days 
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
  # We include the user's own id as well.
  def self.followed_by(user)
    following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
                        where("user_id IN (#{following_ids})",
                              { :user_id => user })
  end

end
