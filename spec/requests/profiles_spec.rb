require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  describe "GET /profile" do

    let!(:user) { User.create(first_name: 'Foo', last_name: 'Bar', email: 'foo@bar.com', password: 'foobar') }

    before do
      login_as(user, scope: :user)
    end

    it 'shows the profile page' do
      get profile_path
      expect(response).to have_http_status(:success)
    end
  end
end
