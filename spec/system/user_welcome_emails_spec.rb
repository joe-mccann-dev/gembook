require 'rails_helper'

RSpec.describe "UserWelcomeEmails", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.new(first_name: 'abcde3456fg', last_name: 'hijklmno', email: 'abcdefg@hijklmno.com', password: '123456')}

  it 'sends them a welcome email' do
    visit new_user_registration_path
    fill_in :user_first_name, with: user.first_name
    fill_in :user_last_name, with: user.last_name
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    fill_in :user_password_confirmation, with: user.password
    expect { click_on 'Sign up' }.to change { ActionMailer::Base.deliveries.count}.by(1)
  end
end
