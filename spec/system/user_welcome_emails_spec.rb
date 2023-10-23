require 'rails_helper'

RSpec.describe "UserWelcomeEmails", type: :system do
  before do
    driven_by(:selenium)
  end

  let!(:user) { User.new(first_name: 'abcde3456fg', last_name: 'hijklmno', email: 'abcdefg@hijklmno.com', password: '123456')}

  before(:each) do
    OmniAuth.config.add_mock(:github, {info: { email: 'iamoauth@user.com', name: 'Full Name', image: 'https://unsplash.com/photos/7TjeBRFGAQY/download?ixid=MnwxMjA3fDB8MXxhbGx8M3x8fHx8fDJ8fDE2NjA3MTYxMjg&force=true&w=640' } })
  end

  it 'sends them a welcome email' do
    expect(ActionMailer::Base.deliveries.count).to eq(0)
    visit new_user_registration_path
    fill_in :user_first_name, with: user.first_name
    fill_in :user_last_name, with: user.last_name
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    fill_in :user_password_confirmation, with: user.password
    click_on "Sign up"
    expect(page).to have_content("Welcome")
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it 'sends first time oauth users a welcome email' do
    expect(ActionMailer::Base.deliveries.count).to eq(0)
    visit new_user_registration_path
    click_on 'Sign in with GitHub'
    expect(page).to have_content("Welcome")
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it 'does not send welcome email to already registered oauth users' do
    visit new_user_registration_path
    expect(ActionMailer::Base.deliveries.count).to eq(0)
    click_on 'Sign in with GitHub'
    expect(page).to have_content("Welcome")
    current_delivery_count = 1
    expect(ActionMailer::Base.deliveries.count).to eq(current_delivery_count)
    click_on "Sign out"
    click_on 'Sign in with GitHub'
    expect(ActionMailer::Base.deliveries.count).to eq(current_delivery_count)
  end
end
