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
  end
end
