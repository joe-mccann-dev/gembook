require 'rails_helper'

RSpec.describe "ProfilePictures", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  
  context 'a user wants to upload a profile picture' do
    before do
      login_as(user, scope: :user)
      visit new_user_profile_path(user)
    end

    context 'Image files' do
      it 'allows jpg files' do
        image_1_file_path = "#{Rails.root}/spec/files/image_1.jpg"
        attach_file(image_1_file_path)
        find("#profile_profile_picture").click
        click_on "Submit Profile"
        expect(page).to have_content("You've successfully created your profile")
      end
  
      it 'allows png files' do
        image_2_file_path = "#{Rails.root}/spec/files/image_2.png"
        attach_file(image_2_file_path)
        find("#profile_profile_picture").click
        click_on "Submit Profile"
        expect(page).to have_content("You've successfully created your profile")
      end
  
      it 'allows jpeg files' do
        image_1_jpeg_file_path = "#{Rails.root}/spec/files/image_1_jpeg.jpeg"
        attach_file(image_1_jpeg_file_path)
        find("#profile_profile_picture").click
        click_on "Submit Profile"
        expect(page).to have_content("You've successfully created your profile")
      end
  
      it 'does not allow TIFF format images' do
        image_3_file_path = "#{Rails.root}/spec/files/image_3.tiff"
        attach_file(image_3_file_path)
        find("#profile_profile_picture").click
        click_on "Submit Profile"
        expect(page).to have_content('Profile picture has an invalid content type')
      end
  
      it 'does not allow GIF format images' do
        image_4_file_path = "#{Rails.root}/spec/files/image_4.gif"
        attach_file(image_4_file_path)
        find("#profile_profile_picture").click
        click_on "Submit Profile"
        expect(page).to have_content('Profile picture has an invalid content type')
      end
    end

    context 'non-image files' do
      it 'does not allow pdf files' do
        pdf_file_path = "#{Rails.root}/spec/files/sample.pdf"
        attach_file(pdf_file_path)
        find("#profile_profile_picture").click
        click_on "Submit Profile"
        expect(page).to have_content('Profile picture has an invalid content type')
      end

      it 'does not allow mp3 files' do
        mp3_file_path = "#{Rails.root}/spec/files/sample.mp3"
        attach_file(mp3_file_path)
        find("#profile_profile_picture").click
        click_on "Submit Profile"
        expect(page).to have_content('Profile picture has an invalid content type')
      end

      it 'does not allow json files' do
        json_file_path = "#{Rails.root}/spec/files/sample.json"
        attach_file(json_file_path)
        find("#profile_profile_picture").click
        click_on "Submit Profile"
        expect(page).to have_content('Profile picture has an invalid content type')
      end
    end
  end
end
