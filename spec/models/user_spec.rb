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

require 'spec_helper'

describe User do
  before do
    @user = User.new( username: "johnkowalski", fullname: "John Kowalski",
              email: "john@example.net", password: "foobar")
  end
  
  subject { @user }

  it { should respond_to(:items) }
  it { should be_valid }

  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when username is too long" do
    before { @user.username = "a" * 21 }
    it { should_not be_valid }
  end

  describe "when fullname is not present" do
    before { @user.fullname = " " }
    it { should_not be_valid }
  end

  describe "when fullname is too long" do
    before { @user.fullname = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    addresses = %w[user@foo,com users_at_foo.org example.user@foo.]
    addresses.each do |address|
      before { @user.email = address }
      it { should_not be_valid }
    end
  end

  describe "when email format is valid" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.name@foo.jp]
    addresses.each do |address|
      before { @user.email = address }
      it { should be_valid }
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when username is already taken" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.username = @user.username.upcase
      user_with_same_username.save
    end
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = "a" * 4 }
    it { should_not be_valid }
  end

  describe "when password is too long" do
    before { @user.password = "a" * 26 }
    it { should_not be_valid }
  end

  describe "when fullname is too long" do
    before { @user.fullname = "a" * 31 }
    it { should_not be_valid }
  end

end
