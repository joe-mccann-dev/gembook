require 'rails_helper'

RSpec.describe Profile, type: :model do
  
  let!(:user) { User.create!(first_name: 'Foo', last_name: 'Bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:profile) { user.create_profile(nickname: 'Fooey', bio: 'I enjoy foo and bars', current_city: 'New York', hometown: 'Springfield') }

  it 'belongs to a user' do
    expect(profile.user).to eq(user)
  end

  it { is_expected.to validate_content_type_of(:profile_picture).allowing('image/png', 'image/jpg', 'image/jpeg') }
  it { is_expected.to validate_size_of(:profile_picture).less_than(10.megabytes) }

end
