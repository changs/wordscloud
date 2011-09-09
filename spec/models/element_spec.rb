require 'spec_helper'

describe Item do
  before(:each) do
    @user = Factory(:user)
    @attr = { question: "Question", answer: "Answer" }
  end
   
  it "should add item given valid parameters" do
    el = @user.items.create!(@attr)
    el.should be_valid
  end

  it "should not add item given invalid parameters" do
    el = @user.items.new(@attr.merge(question: ""))
    el.should_not be_valid
  end

  it "should not add item given invalid parameters" do
    el = @user.items.new(@attr.merge(answer: ""))
    el.should_not be_valid
  end

  describe 'Algorithm' do
    it "should return an item if interval is correct" do
      el = @user.items.create!(@attr)
      el.review_at -= 1.day
      el.save
      Item.next_review_at(@user).should eq(el)
    end

    it "should not return an item if interval is incorrect" do
      el = @user.items.create!(@attr)
      Item.next_review_at(@user).should be_nil
    end
  end
end
