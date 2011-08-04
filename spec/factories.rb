Factory.define :user do |f|
  f.sequence(:username) { |n| "john#{n}" }
  f.fullname  'Doe'
  f.sequence(:email) { |n| "test#{n}@example.com" }
  f.password 'foobar'
end
