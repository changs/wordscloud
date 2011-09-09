require 'spec_helper'

describe User do
  before(:each) do
    @attr = { username: "johnkowalski", fullname: "John Kowalski",
              email: "john@example.net", password: "foobar" }
  end

  describe "Create a user" do

    it "should create a new instance given valid attributes" do
      User.create!(@attr)
    end
 
    it "should require a name" do
      invalid_user = User.new(@attr.merge(username: ""))
      invalid_user.should_not be_valid
    end

    it "should require a fullname" do
      invalid_user = User.new(@attr.merge(fullname: ""))
      invalid_user.should_not be_valid
    end

    it "should require an email" do
      invalid_user = User.new(@attr.merge(email: ""))
      invalid_user.should_not be_valid
    end

    it "should require a password" do
      invalid_user = User.new(@attr.merge(password: ""))
      invalid_user.should_not be_valid
    end

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.name@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(email: address))
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com users_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(email: address))
        invalid_email_user.should_not be_valid
      end
    end

    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(email: upcased_email, username: "paul"))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject username identical up to case" do
      User.create!(@attr.merge(username: @attr[:username].upcase, email: "paul@foo.net"))
      user_with_duplicate_username = User.new(@attr)
      user_with_duplicate_username.should_not be_valid
    end

    it "should reject duplicate usernames" do
      User.create!(@attr)
      user_with_duplicate_username = User.new(@attr.merge(email: "paul@example.net"))
      user_with_duplicate_username.should_not be_valid
    end

    it "should reject duplicate email addresses" do
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr.merge(username: "paulkowalski"))
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject password shorter than 5 chars" do
      user_with_short_password = User.new(@attr.merge(password: "aa"))
      user_with_short_password.should_not be_valid
    end

    it "should reject password longer than 25 chars" do
      user_with_long_password = User.new(@attr.merge(password: "a"*26))
      user_with_long_password.should_not be_valid
    end

    it "should reject username longer than 20 chars" do
      user_with_long_username = User.new(@attr.merge(username: "a"*21))
      user_with_long_username.should_not be_valid
    end

    it "should reject fullname longer than 30 chars" do
      user_with_long_fullname = User.new(@attr.merge(fullname: "a"*31))
      user_with_long_fullname.should_not be_valid
    end
    
    it "should have 2 different auth_token for users with the same password" do
      first_user = User.create!(@attr)
      second_user = User.create!(@attr.merge(username: "second", email: "second@o.com"))
      first_user.auth_token.should_not == second_user.auth_token
    end
  end

  it "should respond do items" do
    user = User.new(@attr)
    user.should respond_to(:items)
  end
end
