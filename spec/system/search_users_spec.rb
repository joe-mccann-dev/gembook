require 'rails_helper'

RSpec.describe "SearchUsers", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'Thomas', last_name: 'Jefferson', email: 'thomas@jefferson.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'John', last_name: 'Hancock', email: 'john@hancock.com', password: 'foobar') }

  describe 'searching for a user' do
    context 'a user is logged in at users#index' do
      before do
        login_as(user, scope: :user)
        visit users_path
      end

      it 'allows them to enter a query and shows them results' do
        query = other_user.first_name
        fill_in 'query', with: query
        click_on 'Search'
        expect(page).to have_content('Search Results')
        expect(page).to have_content(other_user.full_name)
      end

      it "Shows 'No users found' if there are no matches" do
        query = 'Joe'
        fill_in 'query', with: query
        click_on 'Search'
        expect(page).to have_content('Search Results')
        expect(page).to have_content('No users found')
      end
    end
  end
end
