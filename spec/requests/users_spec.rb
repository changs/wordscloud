require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }
    it { should have_selector('h2', text: "Create a new user") }
  end

  describe "signup" do
    before { visit signup_path }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button "Create my account" }.not_to change(User, :count)
      end
      describe "error messages" do
        before { click_button "Create my account" }
        it { should have_content('You are almost done') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Fullname", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Username", with: "User"
      end

      it "should create a user" do
        expect { click_button "Create my account" }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button "Create my account" }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_content("#{user.username} - #{user.fullname}") }
        it { should have_selector("div.note_success", text: "created") }
        it { should have_link("Sign out") }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Edit") }
    end

    describe "with invalid information" do
      before do
        fill_in "Username", with: " "
        click_button "Save changes"
      end
      it { should have_selector("div#error_explanation") }
    end

    describe "with valid information" do
      let(:new_username) { "NewUsername" }
      before do
        fill_in "Username", with: new_username
        click_button "Save changes"
      end

      it { should have_selector("div.note_success") }
      specify { user.reload.username.should == new_username }
    end
  end

  describe "profile" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:i1) { FactoryGirl.create(:item, user: user) }
    let!(:i2) { FactoryGirl.create(:item, user: user) }

    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_content("#{user.username} - #{user.fullname}")}
    it { should have_content("Items: 2") }

    describe "follow/unfollow buttons" do
      let(:user2) { FactoryGirl.create(:user) }
      let!(:i3) { FactoryGirl.create(:item, user: user2) }
      let!(:i4) { FactoryGirl.create(:item, user: user2) }

      describe "following a user" do
        before do
          visit user_path(user2)
        end

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.following, :count).by(1)
        end

        it "should increment user2's followers count" do
          expect do
            click_button "Follow"
          end.to change(user2.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: "Unfollow") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(user2)
          visit user_path(user2)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.following, :count).by(-1)
        end

        it "should decrement user2's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(user2.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end

    end
  end
end
