Factory.define :user do |f|
  f.sequence(:username) { |n| "john#{n}" }
  f.fullname  'Doe'
  f.sequence(:email) { |n| "test#{n}@example.com" }
  f.password 'foobar'
end

Factory.define :element do |f|
  f.sequence(:question) { |n| "Question #{n}" }
  f.sequence(:answer) { |n| "Answer #{n}" }
  f.association :user
end
