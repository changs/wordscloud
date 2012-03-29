require 'spec_helper'

describe "Items" do
  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in "Username", with: @user.username
    fill_in "Password", with: @user.password
    click_button "Sign in"
  end
    
  describe "GET /review" do
    it "it should show message when there is no items for today" do
      visit '/review'
      page.should have_css("div.note_notice")
      current_path.should eq(user_path(@user))
    end

    it "user can add an item given valid attributes" do
      visit '/new_item'
      fill_in "item_question", with: 'Rower'
      fill_in "item_answer", with: 'Bicycle'
      click_button "Add item"
      page.should have_css("div.note_success")
    end

    it "user can't add an item given invalid attributes" do
      visit '/new_item'
      fill_in "item_question", with: ''
      fill_in "item_answer", with: 'Bicycle'
      click_button "Add item"
      page.should have_css("div#error_explanation")
    end
    
    it "should allow review when there are some item avaiable" do
      item = Factory(:item, :user => @user)
      item.review_at = 1.day.ago
      item.save
      visit '/review'
      page.should have_content(item.question)
      page.should have_content(item.answer)
    end
  end
end
