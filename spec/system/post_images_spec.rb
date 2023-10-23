require 'rails_helper'

RSpec.describe "PostImages", type: :system do
  before do
    driven_by(:selenium)
  end
  
  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  
  context 'a user wants to post an image' do
    before do
      login_as(user, scope: :user)
      visit user_path(user)
    end

    it 'allows them to post an image' do
      click_on "Show Post Form"
      image_file_path = "#{Rails.root}/spec/files/image_1.jpg"
      attach_file("post_image", image_file_path)
      text_content = "Hello, this is a post with an image"
      fill_in "post_content", with: text_content
      click_on 'Post'
      expect(page).to have_content(text_content)
      expect(page).to have_selector("img[src*='image_1.jpg'][alt='a user posted image']")
    end
  end
end
