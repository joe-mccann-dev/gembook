require 'rails_helper'

RSpec.describe "UnfriendFriend", type: :system do
  before do
    driven_by(:selenium)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'other', last_name: 'user', email: 'other@user.com', password: 'foobar') }

  context "A user wants to 'unfriend' a user they are friends with" do
    before do
      login_as(user, scope: :user)
      visit users_path

      click_button "Show Other Users"
      accept_confirm do
        find("#friend-#{other_user.id}").click
      end
  
      click_on "Sign out"
      fill_in "user_email", with: other_user.email
      fill_in "user_password", with: other_user.password
      click_on "Log in"
      expect(page).to have_content("Recent Posts")
      visit notifications_path
      find("body", text: "new friend request")
      click_on "Accept"

      visit users_path

    end

    it 'allows the user to unfriend a user they are friends with' do
      expect(page).to have_content(user.first_name)

      accept_confirm do
        find('.unfriend').click
      end

      expect(page).to_not have_content(user.first_name)
    end
  end
end
