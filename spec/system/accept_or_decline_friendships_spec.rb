require 'rails_helper'

RSpec.describe 'Accept or Decline Friendships', type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:friend_requester) { User.create(first_name: 'friend', last_name: 'requester', email: 'friend@requester.com', password: 'foobar') }
  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context 'the friend requester is signed in at the users#index page' do
    before do
      login_as(friend_requester, scope: :user)
      visit users_path

      find("#friend-#{user.id}").click

      logout(:friend_requester)
      login_as(user, scope: :user)

      visit users_path
    end

    it 'shows they have 1 unread notification' do
      expect(page).to have_content('1 unread notification')
    end

    context 'the user clicks the notifications link' do
      it 'shows them the friend request' do
        click_link '1 unread notification'
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
