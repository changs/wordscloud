FactoryGirl.define do
  factory :user do 
    sequence(:username) { |n| "john#{n}" }
    fullname  'Doe'
    sequence(:email) { |n| "test#{n}@example.com" }
    password 'foobar'
  end

  factory :item do
    sequence(:question) { |n| "Question #{n}" }
    sequence(:answer) { |n| "Answer #{n}" }
    user
  end
end
