require 'spec_helper'

describe Item do
  let(:user) { FactoryGirl.create(:user) }
  before { @item = user.items.build(question: "Q", answer: "A") }

  subject { @item }

  it { should be_valid }
  its(:user) { should == user }

  describe "when question is not present" do
    before { @item.question = " " }
    it { should_not be_valid }
  end

  describe "when answer is not present" do
    before { @item.answer = " " }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @item.user_id = nil }
    it { should_not be_valid }
  end

  describe "when there is an item to review" do
    before do
      @item.save
      @item.review_at -= 1.day;
      @item.save 
    end
    it "should return the item" do
      Item.next_review_for(user).should eq(@item)
    end
  end

  describe "when there isn't an item to review" do
    it "should not return any item" do
      Item.next_review_for(user).should be_nil
    end
  end

end
