require 'rails_helper'

RSpec.describe "UnfriendFriend", type: :system do
  before do
    driven_by(:selenium_headless)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'other', last_name: 'user', email: 'other@user.com', password: 'foobar') }

  context "A user wants to 'unfriend' a user they are friends with" do
    before do
      login_as(user, scope: :user)
      visit users_path

      click_button "Show Other Users"
      accept_confirm do
        find("#friend-#{other_user.id}").click
      end
  
      find('.logout-link').click
      login_as(other_user, scope: :user)

      visit notifications_path

      find("#accept-sender-#{user.id}-request").click

      visit users_path

    end

    it 'allows the user to unfriend a user they are friends with' do
      click_button "Show Friends"
      accept_confirm do
        find('.unfriend').click
      end
      expect(page).to have_content("You are no longer friends with #{user.first_name}.")
    end

    it 'allows the unfriended user to accept a second friend request after being unfriended' do
      click_button "Show Friends"
      accept_confirm do
        find('.unfriend').click
      end
      expect(page).to have_content("You are no longer friends with #{user.first_name}.")

      # refriend foo
      click_button "Show Other Users"
      accept_confirm do
        find("#friend-#{user.id}").click
      end
      
      expect(page).to have_content("Friend request sent to #{user.first_name}")

      find('.logout-link').click
      login_as(user, scope: :user)

      visit notifications_path
      
      expect(page).to have_content('accept')

      #foo accepts second requests from
      expect(page).to have_button('Accept')
      find("#accept-sender-#{other_user.id}-request").click
      expect(user.received_notifications.unread.count).to eq(0)
      expect(page).to_not have_button('Accept')
    end
  end
end
