require 'rails_helper'

RSpec.describe 'Accept or Decline Friendships', type: :system do
  before do
    driven_by(:rack_test)
    Rails.application.load_seed
  end

  let!(:friend_requester) { User.second }
  let!(:user) { User.last }

  context 'the friend requester is signed in at the users#index page' do
    before do
      login_as(friend_requester, scope: :user)
      visit users_path

      within(find('ul > li:nth-child(4)')) do
        find('.add-friend').click
      end

      logout(:friend_requester)
      login_as(user, scope: :user)

      visit users_path
    end

    it 'shows they have 2 unread notifications' do
      expect(page).to have_content('2 unread notifications')
    end

    context 'the user clicks the notifications link' do
      it 'shows them the friend request' do
        click_link '2 unread notifications'
        name = "#{friend_requester.first_name} #{friend_requester.last_name}"
        expect(page).to have_content("new friend request from #{name}")
      end

      it 'allows them to click accept' do
        visit notifications_path
        within(find('ul > li:nth-child(2) > div')) do
          find('.accept-request').click
        end
        expect(page).to have_content('Friendship accepted!')
      end

      it 'allows them to click decline' do
        visit notifications_path
        within(find('ul > li:nth-child(2) > div')) do
          find('.decline-request').click
        end
        expect(page).to have_content('Friendship declined.')
      end
    end
  end
end
