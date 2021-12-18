require 'rails_helper'

RSpec.describe "UnfriendFriend", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'other', last_name: 'user', email: 'other@user.com', password: 'foobar') }

  context "A user wants to 'unfriend' a user they are friends with" do
    before do
      login_as(user, scope: :user)
      visit users_path

      find("#friend-#{other_user.id}").click

      logout(user, scope: :user)
      login_as(other_user, scope: :user)

      visit notifications_path

      find("#accept-sender-#{user.id}-request").click

      visit users_path

    end

    it 'allows the user to unfriend a user they are friends with' do
      click_on "Unfriend"
      expect(page).to have_content("You are no longer friends with #{user.first_name}.")
    end
  end
end
