require 'rails_helper'

RSpec.describe 'Adding Friends', type: :system do
  before do
    driven_by(:selenium)
  end

  let!(:user) { User.create(first_name: 'john', last_name: 'smith', email: 'john@smith.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'other', last_name: 'user', email: 'other@user.com', password: 'foobar') }
  let!(:another_user) { User.create(first_name: 'another', last_name: 'user', email: 'another@user.com', password: 'foobar') }

  context 'the user is signed in at the users#index page' do
    before do
      login_as(user, scope: :user)
      visit users_path
      click_button "Show Other Users"
    end

    it 'allows them to add a friend by clicking the Add Friend button' do
      accept_confirm do
        find("#friend-#{other_user.id}").click
      end
      expect(page).to have_content("Friend request sent")
      expect(user.sent_pending_requests.count).to eq(1)
    end

    it 'allows them to add another friend by clicking the next Add Friend button' do
      accept_confirm do
        find("#friend-#{another_user.id}").click
      end
      expect(page).to have_content("Friend request sent")
      expect(user.sent_pending_requests.count).to eq(1)
    end
  end
end
