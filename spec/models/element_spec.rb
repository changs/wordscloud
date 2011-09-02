require 'spec_helper'

describe Element do
  before(:each) do
    @user = Factory(:user)
    @attr = { question: "Question", answer: "Answer" }
  end
   
  it "should add element given valid parameters" do
    el = @user.elements.create!(@attr)
    el.should be_valid
  end

  it "should not add element given invalid parameters" do
    el = @user.elements.new(@attr.merge(question: ""))
    el.should_not be_valid
  end

  it "should not add element given invalid parameters" do
    el = @user.elements.new(@attr.merge(answer: ""))
    el.should_not be_valid
  end

  describe 'Algorithm' do
    it "should return an element if interval is correct" do
      el = @user.elements.create!(@attr)
      el.to_review -= 1.day
      el.save
      Element.next_to_review(@user).should eq(el)
    end

    it "should not return an element if interval is incorrect" do
      el = @user.elements.create!(@attr)
      Element.next_to_review(@user).should be_nil
    end
  end
end
