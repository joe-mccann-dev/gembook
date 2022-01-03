require 'rails_helper'

RSpec.describe "PostImages", type: :system do
  before do
    driven_by(:rack_test)
  end
  
  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  
  context 'a user wants to post an image' do
    before do
      login_as(user, scope: :user)
      visit user_path(user)
    end

    it 'allows them to post an image by itself' do
      image_file_path = "#{Rails.root}/spec/files/image_1.jpg"
      attach_file(image_file_path)
      find("#post_image").click
      click_on 'Post'
      expect(page).to have_content('Post created successfully.')
    end

    it 'allows them to post an image accompanied by text content' do
      image_file_path = "#{Rails.root}/spec/files/image_1.jpg"
      attach_file(image_file_path)
      text = 'this is my favorite picture'
      fill_in 'post_content', with: text
      find("#post_image").click
      click_on 'Post'
      expect(page).to have_content(text)
      expect(page).to have_content('Post created successfully.')
    end

    it 'allows them to post text without an image' do
      text = 'this is a post without an image'
      fill_in 'post_content', with: text
      find("#post_image").click
      click_on 'Post'
      expect(page).to have_content(text)
      expect(page).to have_content('Post created successfully.')
    end
  end
end
