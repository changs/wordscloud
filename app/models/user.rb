# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  username        :string(255)
#  fullname        :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  auth_token      :string(255)
#

class User < ActiveRecord::Base
  has_secure_password
  has_many :items, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship",
    dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  attr_accessible :username, :fullname, :email, :password
  before_create { generate_token(:auth_token) }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true, length: { maximum: 20 },
    uniqueness: { case_sensitive: false }
  validates :fullname, presence: true, length: { maximum: 30 }
  validates :email, format: { with: email_regex },
    uniqueness: { case_sensitive: false }, length: { maximum: 30 }
  validates :password, length: { in: 5..25 }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def self.search(search)
    if search
      find(:all, conditions: ['username LIKE ? or fullname LIKE ?', "%#{search}%", "%#{search}%"])
      #find(:all, conditions: ["username LIKE '%#{search}%'  or fullname LIKE ?", "%#{search}%"])
    else
      find(:all)
    end
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(followed_id: followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  def feed
    items = Item.from_users_followed_by(self).where("public = ?", true)
  end
end
