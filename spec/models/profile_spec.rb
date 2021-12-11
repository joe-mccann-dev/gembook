require 'rails_helper'

RSpec.describe Profile, type: :model do
  
  let!(:user) { User.create!(first_name: 'Foo', last_name: 'Bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:profile) { user.create_profile(nickname: 'Fooey', bio: 'I enjoy foo and bars', current_city: 'New York', hometown: 'Springfield') }

  it 'belongs to a user' do
    expect(profile.user).to eq(user)
  end
end
