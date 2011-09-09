class User < ActiveRecord::Base
  has_secure_password
  has_many :items
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
end
