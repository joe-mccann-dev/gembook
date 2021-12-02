require 'rails_helper'

RSpec.describe "Adding Friends", type: :system do
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
      expect { first('.add-friend').click }.to change { user.sent_pending_requests.count }.from(0).to(1)
    end
  end
end
