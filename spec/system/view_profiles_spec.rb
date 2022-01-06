require 'rails_helper'
include UsersHelper

RSpec.describe "ViewProfiles", type: :system do

  before do
    driven_by(:rack_test)
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
        expect(current_path).to eq(new_user_profile_path(user))
      end
    end

    context 'they already have a profile' do
      it "allows them edit their profile after creating one" do
        expect(current_path).to eq(user_path(user))
        expect(page).to have_content("You haven't created a profile yet.")
        click_link 'Create Profile'
        expect(current_path).to eq(new_user_profile_path(user))
        fill_in 'Bio', with: 'My name is Foo and I enjoy coffee and tea'
        fill_in 'Nickname', with: 'Fooey'
        fill_in 'Current City', with: 'Bartown'
        fill_in 'Hometown', with: 'Footown'
        image_1_file_path = "#{Rails.root}/spec/files/image_1.jpg"
        attach_file(image_1_file_path)
        find("#profile_profile_picture").click
        click_on 'Create Profile'
        expect(page).to have_content("You've successfully created your profile.")
        expect(page.current_path).to eq(user_path(user))

        click_link 'Edit Profile'
        expect(page.current_path).to eq(edit_user_profile_path(user))

        fill_in 'Bio', with: 'Updated Bio'
        fill_in 'Nickname', with: 'Updated Nickname'
        fill_in 'Current City', with: 'Updated Current City'
        image_2_file_path = "#{Rails.root}/spec/files/image_2.png"
        attach_file(image_2_file_path)
        find("#profile_profile_picture").click
        click_on 'Edit Profile'
        expect(page.current_path).to eq(user_path(user))
        expect(page).to have_content("You've successfully edited your profile.")
      end

      it 'profile picture is a resized image that is a link to full sized image' do
        click_link 'Create Profile'
        expect(current_path).to eq(new_user_profile_path(user))
        image_1_file_path = "#{Rails.root}/spec/files/image_1.jpg"
        attach_file(image_1_file_path)
        find("#profile_profile_picture").click
        click_on 'Create Profile'
        expect(page).to have_css("#profile-#{user.profile.id}-picture")
        click_link "profile-#{user.profile.id}-picture"
        
        # path helpers did not work due to the way active storage creates links in test environment
        desired_end_of_url = "image_1.jpg"
        end_length = desired_end_of_url.length
        url_length = current_url.length
        end_of_url = "#{current_url[-end_length..url_length]}"
        expect(end_of_url).to eq(desired_end_of_url)
      end
    end
  end

  context 'A user wants to create a new post from their profile page' do
    before do
      login_as(user, scope: :user)
      visit user_path(user)
    end

    it 'allows them to create a new post and redirects to current path' do
      expect(page.current_path).to eq(user_path(user))
      post = 'A new post by Foo'
      fill_in 'post_content', with: post
      click_on 'Post'
      expect(page).to have_content('Post created successfully.')
      expect(page.current_path).to eq(user_path(user))
      expect(page).to have_content(post)
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
        link = "Send #{user.first_name} a friend request"
        message = "You sent #{user.first_name} a friend request. Once they accept you'll be able to see their posts."
        expect { click_link link }.to change { user.received_pending_requests.count }.from(0).to(1)
        expect(page).to have_content(message)
      end
    end

    context "viewed user has already sent them a friend request" do
      before do
        login_as(other_user, scope: :user)
        visit users_path

        click_on "Add Friend"
        logout(other_user, scope: :user)
        login_as(user, scope: :user)

        visit user_path(other_user)
      end

      it "offers them an 'accept friend request' link" do
        message = "#{other_user.first_name} sent you a friend request. Once you accept you'll be able to see their posts."
        link = "Accept request"

        expect(page).to have_content(message)
        expect(page).to have_content(link)
        expect { click_link link }.to change { user.received_accepted_requests.count }.from(0).to(1)
      end
    end

    context "they have already sent viewed user a friend request" do
      before do
        login_as(user, scope: :user)
        visit users_path

        click_on "Add Friend"
      end

      it 'does not show send a friend request link' do
        link = "Send #{other_user.first_name} a friend request"
        visit user_path(other_user)
        expect(page).to_not have_link(link)
      end
    end

    context 'they have already accepted a request from the profile page' do
      before do
        login_as(user, scope: :user)
        visit users_path

        click_on 'Add Friend'
        logout(user, scope: :user)
        login_as(other_user, scope: :user)
        visit user_path(user)
      end

      it 'does not show accept request' do
        link = 'Accept request'
        click_link link
        expect(page).to_not have_link(link)
      end
    end
  end
end
