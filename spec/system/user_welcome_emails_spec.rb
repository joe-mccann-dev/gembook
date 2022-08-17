require 'rails_helper'

RSpec.describe "UserWelcomeEmails", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.new(first_name: 'abcde3456fg', last_name: 'hijklmno', email: 'abcdefg@hijklmno.com', password: '123456')}

  before(:each) do
    OmniAuth.config.add_mock(:github, {info: { email: 'iamoauth@user.com', name: 'Full Name', image: 'https://unsplash.com/photos/7TjeBRFGAQY/download?ixid=MnwxMjA3fDB8MXxhbGx8M3x8fHx8fDJ8fDE2NjA3MTYxMjg&force=true&w=640' } })
  end

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
    find('.logout-link').click
    expect { click_link 'Sign in with GitHub' }.to change { ActionMailer::Base.deliveries.count}.by(0)
  end
end
