require 'spec_helper'

describe "Users" do
  describe "get /signup" do
    it "should not create account with invalid parameters" do
      lambda do
        visit signup_path
        fill_in "Fullname", with: ""
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        fill_in "Username", with: ""
        click_button "Create my account"
        page.should have_css("div#error_explanation")
      end.should_not change(User, :count)
    end

    it "should create account with valid parameters" do
      lambda do
        visit signup_path
        fill_in "Fullname", with: "Foo Bar"
        fill_in "Email", with: "foo@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Username", with: "foo"
        click_button "Create my account"
        page.should have_content("Your account has been created")
      end.should change(User, :count).by(1)
    end

    it "should edit user's account with valid parameters" do
      user = Factory(:user)
      visit edit_user_path(user)
      fill_in "Username", with: "new_username"
      fill_in "Password", with: "foobar"
      click_button "Save changes"
      page.should have_content("updated")
      page.should have_content("new_username")
      current_path.should eq(user_path(user))
    end
  end
end
