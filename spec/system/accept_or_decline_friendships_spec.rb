require 'rails_helper'

RSpec.describe 'Accept or Decline Friendships', type: :system do
  before do
    driven_by(:selenium_headless)
  end

  let!(:friend_requester) { User.create(first_name: 'friend', last_name: 'requester', email: 'friend@requester.com', password: 'foobar') }
  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context 'the friend requester is signed in at the users#index page' do
    before do
      login_as(friend_requester, scope: :user)
      visit users_path

      click_button 'Show Other Users'
      accept_confirm do
        find("#friend-#{user.id}").click
      end
      
      find('.logout-link').click
      login_as(user, scope: :user)

      visit users_path
    end

    it 'shows them the notification' do
      visit notifications_path
      expect(page).to have_css(".notifications-bell")
      expect(page).to have_content('new friend request')
    end

    context 'the user clicks the notifications link' do
      it 'shows them the friend request' do
        
        find('.notifications-link').click
        name = "#{friend_requester.first_name} #{friend_requester.last_name}"
        expect(page).to have_content("new friend request from #{name}")
      end

      it 'allows them to click accept' do
        visit notifications_path
        find("#accept-sender-#{friend_requester.id}-request").click
        expect(page).to have_content('Friendship accepted!')
      end

      it 'allows them to click decline' do
        visit notifications_path
        find("#decline-sender-#{friend_requester.id}-request").click
        expect(page).to have_content('Friendship declined.')
      end
    end
  end
end
