require 'rails_helper'

RSpec.describe "ViewProfiles", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'other', last_name: 'user', email: 'other@user.com', password: 'foobar') }

  context "a user wants to view another user's profile" do
    before do
      login_as(user, scope: :user)
    end

    it 'redirects to root if other user is not a friend' do
      visit user_path(other_user)
      expect(page).to have_content("You must be friends to view this user's profile.")
      expect(current_path).to eq(root_path)
    end
  end
end
