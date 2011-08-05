require 'spec_helper'

describe "Session" do

  it "should not create a session when given invalid username/password" do
    visit signin_path
    fill_in "Username", with: ""
    fill_in "Password", with: ""
    click_button "Sign in"

    page.should have_content("Wrong username or password")
  end

  it "should create a session when given valid username and password" do
    visit signin_path
    user = Factory(:user)
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "Sign in"

    page.should have_content("signed in")
    current_path.should eq(user_path(user))
  end

  it "should end a session when get /signout" do
    visit signout_path
    page.should have_content("signed out")
    current_path.should eq(root_path)
  end

  it "should not allow edit user by another user" do
    user = Factory(:user)
    user2 = Factory(:user)
    signin user
    visit edit_user_path(user2)
    page.should have_content("not allowed")
  end

  it "should remember form values after invalid validation" do
    visit signin_path
    fill_in "Username", with: "foobar"
    check "Remember me"
    click_button "Sign in"

    find_field("Username").value.should == "foobar"
    find_field("Remember me").should be_checked
  end
end
