require 'rails_helper'

RSpec.describe "EditPosts", type: :system do
  before do
    driven_by(:selenium)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context "A user wants to edit their post" do
    before do
      login_as(user, scope: :user)
    end

    it 'allows them to edit post from Posts#index' do
      visit user_path(user)
      
      post_content = 'This is a post I will edit later'

      click_on "Show Post Form"
      fill_in 'post_content', with: post_content

      click_on 'Post'
      visit posts_path

      expect(page).to have_content(post_content)
      expect(page).to have_button('edit post')

      click_on 'edit post' 

      edited_content = 'This is an edited post'
      fill_in 'post_content', with: edited_content
      click_on 'Post'

      expect(page).to have_content(edited_content)
    end

    it 'allows them to edit post from Users#show' do
      visit user_path(user)
    
      click_on "Show Post Form"
    
      post_content = 'This is a post I will edit later'
    
      fill_in 'post_content', with: post_content
    
      click_on 'Post'
      expect(page).to have_content(post_content)
      expect(page).to have_content("Show Post Form")
    
      click_on "edit post"
      fill_in "post_content", with: "this is an edited post"
      click_on "Post"
      sleep(5)
      find("body", text: "this is an edited post")    
      expect(page).to have_content("this is an edited post")
    end
  end
end
