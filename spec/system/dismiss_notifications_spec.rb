require 'rails_helper'

RSpec.describe "DismissNotifications", type: :system do
  before do
    driven_by(:rack_test)
    Rails.application.load_seed
  end

  let!(:notified_user) { User.second}
  let!(:request_accepter) { User.last }

  context 'a user sends a friend request and request is accepted' do

    before do
      login_as(notified_user, scope: :user)
      visit users_path
      
      within(find('ul > li:nth-child(4)')) do
        find('.add-friend').click
      end

      logout(notified_user)
      login_as(request_accepter, scope: :user)
      visit notifications_path
      within(find('ul > li:first > div')) do
        find('.accept-request').click
      end
      logout(request_accepter)
      login_as(notified_user)
    end

    it 'shows the sender of the request a notification and allows them to dismiss it' do
      notified_user.received_notifications.create(sender: request_accepter, object_type: 'Friendship', description: 'accepted your friend request')
      click_link '1 unread notifications'
      visit notifications_path
      expect(current_path).to eq(notifications_path)
      name = "#{request_accepter.first_name} #{request_accepter.last_name}"
      expect(page).to have_content("#{name} accepted your friend request")

      notification = notified_user.received_notifications.first
      find("#dismiss-notification-#{notification.id}").click
      expect(page).to_not have_css('.dismiss-notification')
    end
  end
end
