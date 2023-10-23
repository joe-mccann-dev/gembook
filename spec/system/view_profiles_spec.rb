require 'rails_helper'
include UsersHelper

RSpec.describe "ViewProfiles", type: :system do

  before do
    driven_by(:selenium)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'other', last_name: 'user', email: 'other@user.com', password: 'foobar') }

  context 'users viewing profiles' do
    before do
      login_as(user, scope: :user)
      visit user_path(user)
    end

    context 'they do not yet have a profile' do
      it "allows them to click 'Create Profile'" do
        expect(current_path).to eq(user_path(user))
        expect(page).to have_content("You haven't created a profile yet.")
        click_link 'Create Profile'
        expect(page).to have_content("Create a Profile")
        expect(current_path).to eq(new_user_profile_path(user))
      end
    end

    context 'they already have a profile' do
      it "allows them edit their profile after creating one" do
        expect(current_path).to eq(user_path(user))
        expect(page).to have_content("You haven't created a profile yet.")
        click_link 'Create Profile'
        expect(page).to have_content("Create a Profile")
        expect(current_path).to eq(new_user_profile_path(user))
        fill_in 'Bio', with: 'My name is Foo and I enjoy coffee and tea'
        fill_in 'Nickname', with: 'Fooey'
        fill_in 'Current City', with: 'Bartown'
        fill_in 'Hometown', with: 'Footown'
        image_1_file_path = "#{Rails.root}/spec/files/image_1.jpg"
        attach_file("profile_profile_picture", image_1_file_path)
        
        click_on 'Submit Profile'
        expect(page).to have_content("You've successfully created your profile.")
        expect(page.current_path).to eq(user_path(user))

        click_link 'Edit Profile'
        expect(page).to have_content("Edit Your Profile")
        expect(page.current_path).to eq(edit_user_profile_path(user))

        fill_in 'Bio', with: 'Updated Bio'
        fill_in 'Nickname', with: 'Updated Nickname'
        fill_in 'Current City', with: 'Updated Current City'
        image_2_file_path = "#{Rails.root}/spec/files/image_2.png"
        attach_file("profile_profile_picture", image_2_file_path)
        click_on 'Submit Profile'
        expect(page).to have_content(user.full_name)
        expect(page.current_path).to eq(user_path(user))
        expect(page).to have_content("You've successfully edited your profile.")
      end
    end
  end

  context 'A user wants to create a new post from their profile page' do
    before do
      login_as(user, scope: :user)
      visit user_path(user)
    end

    it "shows them 'Your posts' if they're logged in" do
      expect(page).to have_content('Your Posts')
    end
  end

  context "Viewing friends' posts" do
    before do
      friendship = Friendship.create(sender: user, receiver: other_user)
      friendship.accepted!
    end

    it "shows them posts by 'other user' if viewing another profile" do
      post = user.posts.create(content: 'hey this is a post by Foo')
      login_as(other_user, scope: :user)
      visit user_path(user)
      expect(page).to have_content("Posts by #{user.full_name}")
      expect(page).to have_content(post.content)
    end

    it "shows them a message if there are no posts by their friend" do
      login_as(other_user, scope: :user)
      visit user_path(user)
      expect(page).to have_content("Posts by #{user.full_name}")
      message = "There doesn't seem to be anything here."
      expect(page).to have_content(message)
    end
  end

  context "Trying to view non-friends' posts" do
    it "shows them a message informing user they must be friends with owner of profile page before seeing their posts" do
      login_as(other_user, scope: :user)
      visit user_path(user)
      link_message = "Send #{user.first_name} a friend request"
      rest_of_message = "to see their posts."
      expect(page).to have_content("#{link_message} #{rest_of_message}")
    end

    context "they are not friends with viewed user" do
      before do
        login_as(other_user, scope: :user)
        visit user_path(user)
      end

    it "offers them a 'send friend request' link if they are not friends" do
        link = "Send #{user.first_name} a friend request"
        expect(page).to have_content(link)
      end

      it 'shows a message after sending a friend request from profile page' do
        button_text = "Send #{user.first_name} a friend request"
        message = "Friend request sent"
        expect(user.received_pending_requests.count).to eq(0)
        accept_confirm do
          click_on button_text
        end
        expect(page).to have_content(message)
        expect(user.received_pending_requests.count).to eq(1)        
      end
    end

    context "viewed user has already sent them a friend request" do
      before do
        Capybara.current_driver = Capybara.javascript_driver
        login_as(other_user, scope: :user)
      end

      it "offers them an 'accept friend request' link" do
        visit users_path

        click_on "Show Other Users"
        
        accept_confirm do
          click_on "Add Friend"
        end

        click_on "Sign out"
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_on "Log in"

        expect(page).to have_content("Recent Posts")
        visit user_path(other_user)
        expect(page).to have_content(other_user.full_name)
        
        message = "#{other_user.first_name} sent you a friend request. Once you accept you'll be able to see their posts."
        button_text = "Accept friend request from #{other_user.first_name}"
        expect(page).to have_content(message)
        expect(page).to have_content(button_text)

        expect(user.received_accepted_requests.count).to eq(0)
        accept_confirm do
          click_on button_text
        end
        expect(page).to have_content('Friendship accepted')
        expect(user.received_accepted_requests.count).to eq(1)
      end
    end

    context "they have already sent viewed user a friend request" do
      before do
        Capybara.current_driver = Capybara.javascript_driver
        login_as(user, scope: :user)
      end

      it 'does not show send a friend request link' do
        visit users_path

        click_on "Show Other Users"
        accept_confirm do
          click_on 'Add Friend'
        end

        sleep(1)
        link = "Send #{other_user.first_name} a friend request"
        visit user_path(other_user)
        expect(page).to have_content("You sent #{other_user.first_name} a friend request.")
        expect(page).to_not have_link(link)
      end
    end

    context 'they have already accepted a request from the profile page' do
      before do
        Capybara.current_driver = Capybara.javascript_driver
        login_as(user, scope: :user)
      end

      it 'does not show accept request' do
        visit users_path

        click_on "Show Other Users"
        accept_confirm do
          click_on 'Add Friend'
        end
        
        click_on "Sign out"
        fill_in "user_email", with: other_user.email
        fill_in "user_password", with: other_user.password
        click_on "Log in"
        expect(page).to have_content("Recent Posts")
        visit user_path(user)
        expect(page).to have_content(user.full_name)
        button_text = "Accept friend request from #{user.first_name}"
        expect(page).to have_button(button_text)

        accept_confirm do
          click_on button_text
        end

        expect(page).to have_content('Friendship accepted')
        expect(page).to_not have_button(button_text)
      end
    end
  end
end
