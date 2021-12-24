require 'rails_helper'

RSpec.describe "EditPosts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context "A user wants to edit their post" do
    before do
      login_as(user, scope: :user)
    end

    it 'allows them to edit post from Posts#index' do
      visit user_path(user)
      
      post_content = 'This is a post I will edit later'

      fill_in 'post_content', with: post_content

      click_on 'Post'
      visit posts_path

      expect(page).to have_content(post_content)
      expect(page).to have_link('edit post')

      click_link 'edit post' 

      edited_content = 'This is an edited post'
      fill_in 'post_content', with: edited_content
      click_on 'Post'

      expect(page).to have_content(edited_content)
      expect(page.current_path).to eq(post_path(user.posts.first))

    end

    it 'allows them to edit post from Users#show' do
      visit user_path(user)
      
      post_content = 'This is a post I will edit later'

      fill_in 'post_content', with: post_content

      click_on 'Post'
      visit user_path(user)

      expect(page).to have_content(post_content)
      expect(page).to have_link('edit post')

      click_link 'edit post'
      
      edited_content = 'This is an edited post'
      fill_in 'post_content', with: edited_content
      click_on 'Post'

      expect(page).to have_content(edited_content)
      expect(page.current_path).to eq(post_path(user.posts.first))
    end
  end
end
