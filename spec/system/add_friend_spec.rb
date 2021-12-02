require 'rails_helper'

RSpec.describe 'Adding Friends', type: :system do
  before do
    driven_by(:rack_test)
    Rails.application.load_seed
  end

  let!(:user) { User.last }

  context 'the user is signed in at the users#index page' do
    before do
      login_as(user, scope: :user)
      visit users_path
    end

    it 'allows them to add a friend by clicking the Add Friend button' do
      # due to seeds.rb, first user listed has already requested a friendship with every other user
      # first possible friend to 'add' is the second one in the list.
      within find('ul > li:nth-child(2)') do
        expect { find('.add-friend').click }.to change { user.sent_pending_requests.count }.from(0).to(1)
        expect(page).to have_content('friendship pending')
      end
    end

    it 'allows them to add another friend by clicking the next Add Friend button' do
      within find('ul > li:nth-child(3)') do
        expect { find('.add-friend').click }.to change { user.sent_pending_requests.count }.from(0).to(1)
        expect(page).to have_content('friendship pending')
      end
    end
  end
end
