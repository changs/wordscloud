class Element < ActiveRecord::Base
  attr_accessible :question, :answer, :user
  attr_accessor :grade
  belongs_to :user
  validates :question, presence: true
  validates :answer, presence: true

  before_create { set_default_attr }

  def self.next_to_review(user)
    user.elements.where("to_review <= ?", Time.now.end_of_day ).order('RANDOM()').first
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
    self.to_review = self.updated_at + (self.interval).days 
  end
  def set_default_attr
    self.ef = 2.2
    self.interval = 1
    self.to_review = (Time.now + 1.day)
  end
end
