require 'rails_helper'

RSpec.describe "DismissNotifications", type: :system do
  before do
    driven_by(:selenium)
  end

  let!(:friend_requester) { User.create(first_name: 'notified', last_name: 'user', email: 'notified@user.com', password: 'foobar') }
  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context 'a user sends a request' do
    before do
      login_as(friend_requester, scope: :user)
      visit users_path
      
    end

    it 'allows receiver of request to dismiss the request' do
      click_button 'Show Other Users'
      accept_confirm do
        find("#friend-#{user.id}").click
      end
      
      click_on "Sign out"
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_on "Log in"
      expect(page).to have_content "Recent Posts"
      visit notifications_path

      expect(page).to have_button("Accept")
      expect(page).to have_button("Decline")

      expect(user.received_notifications.unread).to_not be_empty
      click_on "Dismiss"

      expect(page).to_not have_button("Accept")
      expect(page).to_not have_button("Decline")
      
      expect(user.received_notifications.unread).to be_empty
    end
  end
end
