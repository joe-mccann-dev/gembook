require 'rails_helper'

RSpec.describe "ProfilePictures", type: :system do
  before do
    driven_by(:selenium)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  
  context 'a user wants to upload a profile picture' do
    before do
      login_as(user, scope: :user)
      visit new_user_profile_path(user)
    end

    context 'Image files' do
      it 'allows jpg files' do
        image_file_path = "#{Rails.root}/spec/files/image_1.jpg"
        attach_file("profile_profile_picture", image_file_path)
        click_on "Submit Profile"
        expect(page).to have_content("You've successfully created your profile")
      end
  
      it 'allows png files' do
        image_file_path = "#{Rails.root}/spec/files/image_2.png"
        attach_file("profile_profile_picture", image_file_path)

        click_on "Submit Profile"
        expect(page).to have_content("You've successfully created your profile")
      end
  
      it 'allows jpeg files' do
        image_file_path = "#{Rails.root}/spec/files/image_1_jpeg.jpeg"
        attach_file("profile_profile_picture", image_file_path)
        click_on "Submit Profile"
        expect(page).to have_content("You've successfully created your profile")
      end
    end
  end
end
