require 'rails_helper'

RSpec.describe "UpdateUsers", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:registered_with_email) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:registered_with_github) { User.create(provider: 'github', uid: '123456789', first_name: 'github', last_name: 'user', email: 'github@user.com', password: 'github') }

  context 'A user who signed up with their email wants to update their information' do
    before do
      login_as(registered_with_email, scope: :user)
      visit root_url
      click_link 'foo bar'
    end

    it 'allows them to update their password' do
      new_password = 'foobarrred'
      fill_in 'user_password', with: new_password
      fill_in 'user_password_confirmation', with: new_password
      fill_in 'user_current_password', with: 'foobar'
      click_on 'Update'
      expect(page).to have_content('Your account has been updated successfully.')
    end
  end

  context 'A user who signed up with GitHub wants to update their information' do
    before do
      login_as(registered_with_github, scope: :user)
      visit root_url
      click_link 'github user'
    end

    it 'does not allow them to update their password' do
      expect(page).to_not have_css('#user_password')
      expect(page).to_not have_css('#user_password_confirmation')
      expect(page).to_not have_css('#user_current_password')
    end

    it 'allows them to update their first name, last name, or email without a current password' do
      expect(page).to have_css('#user_first_name')
      expect(page).to have_css('#user_last_name')
      expect(page).to have_css('#user_email')

      updated_first =  'git'
      updated_last = 'fan'
      updated_email = 'git@fan.com'

      fill_in 'user_first_name', with: updated_first
      fill_in 'user_last_name', with: updated_last
      fill_in 'user_email', with: updated_email
      click_on 'Update'
      expect(page).to have_content('Your account has been updated successfully.')
    end
  end
end
