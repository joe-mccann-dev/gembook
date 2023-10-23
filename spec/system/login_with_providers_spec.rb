require 'rails_helper'

RSpec.describe "LoginWithProviders", type: :system do
  before do
    driven_by(:selenium)
  end

  describe 'logging in with GitHub' do

    let!(:existing_user) { User.create(first_name: 'John', last_name: 'Hancock', email: 'john@hancock.com', password: 'foobar') }

    context 'a user wants to login with their GitHub account.' do
      before do
        visit new_user_session_path
      end

      context 'valid credentials' do
        it 'allows them to login with GitHub' do
          click_link 'Sign in with GitHub'
          expect(page).to have_content('Successfully authenticated from Github account')
          expect(page).to have_css('.logout-link')
        end

        context 'User is already registered via Devise' do
          it 'redirects with a flash notice' do
            OmniAuth.config.add_mock(:github, {info: { email: existing_user.email, name: existing_user.full_name, image: 'https://via.placeholder.com/400' } })
            click_link 'Sign in with GitHub'
            expect(page).to have_content('Account email is already registered with this site.')
            expect(page.current_path).to eq(new_user_registration_path)
          end
        end
      end

      context 'invalid credentials' do
        before do
          OmniAuth.config.mock_auth[:github] = :invalid_credentials
        end

        it 'fails and redirects' do
          click_link 'Sign in with GitHub'
          expect(page).to have_link 'Sign up'
          expect(page).to_not have_link 'Sign out'
        end
      end
    end
  end
end
