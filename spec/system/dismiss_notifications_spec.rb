require 'rails_helper'

RSpec.describe "DismissNotifications", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:friend_requester) { User.create(first_name: 'notified', last_name: 'user', email: 'notified@user.com', password: 'foobar') }
  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context 'a user sends a friend request and request is accepted' do

    before do
      login_as(friend_requester, scope: :user)
      visit users_path
      
      find("#friend-#{user.id}").click

      logout(friend_requester)
      login_as(user, scope: :user)
      visit notifications_path

      find("#accept-sender-#{friend_requester.id}-request").click

      logout(user)
      login_as(friend_requester)

      visit notifications_path
    end

    it 'shows the sender of the request a notification and allows them to dismiss it' do
      click_link '1 unread notification'
      visit notifications_path
      expect(current_path).to eq(notifications_path)
      name = "#{user.first_name} #{user.last_name}"
      expect(page).to have_content("#{name} accepted your friend request")

      notification = friend_requester.received_notifications.first
      find("#dismiss-notification-#{notification.id}").click
      expect(page).to_not have_css('.dismiss-notification')
    end
  end

  context 'a user sends a request' do
    before do
      login_as(friend_requester, scope: :user)
      visit users_path
      
      find("#friend-#{user.id}").click
    end

    it 'allows receiver of request to dismiss the request' do
      logout(friend_requester)
      login_as(user, scope: :user)
      visit notifications_path

      expect(page).to have_button("Accept")
      expect(page).to have_button("Decline")
      expect(page).to have_button("Dismiss")

      expect(user.received_notifications.unread).to_not be_empty
      click_on "Dismiss"
      expect(user.received_notifications.unread).to be_empty
    end
  end
end
