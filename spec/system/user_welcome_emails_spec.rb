require 'rails_helper'

RSpec.describe "UserWelcomeEmails", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.new(first_name: 'abcde3456fg', last_name: 'hijklmno', email: 'abcdefg@hijklmno.com', password: '123456')}
  let!(:registered_with_github) { User.create(provider: 'github', uid: '123456789', first_name: 'github', last_name: 'user', email: 'github@user.com', password: 'github') }

  it 'sends them a welcome email' do
    visit new_user_registration_path
    fill_in :user_first_name, with: user.first_name
    fill_in :user_last_name, with: user.last_name
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    fill_in :user_password_confirmation, with: user.password
    expect { click_on 'Sign up' }.to change { ActionMailer::Base.deliveries.count}.by(1)
  end

  it 'sends first time oauth users a welcome email' do
    visit new_user_registration_path
    expect { click_link 'Sign in with GitHub' }.to change { ActionMailer::Base.deliveries.count}.by(1)
  end

  it 'does not send welcome email to already registered oauth users' do
    visit new_user_registration_path
    expect { click_link 'Sign in with GitHub' }.to change { ActionMailer::Base.deliveries.count}.by(1)
    click_link 'Sign out'
    expect { click_link 'Sign in with GitHub' }.to change { ActionMailer::Base.deliveries.count}.by(0)
  end
end
