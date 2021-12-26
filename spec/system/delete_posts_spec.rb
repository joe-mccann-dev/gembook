require 'rails_helper'

RSpec.describe "DeletePosts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context "A user has posted something" do
    before do
      login_as(user, scope: :user)
    end

    it 'allows them to delete it from the Posts#index page' do
      visit user_path(user)

      post_content = 'This is my first post. Might delete later'

      fill_in 'post_content', with: post_content
      
      click_on 'Post'
      visit posts_path
      expect(page).to have_content(post_content)
      expect(page).to have_link('delete post')

      expect { click_link 'delete post' }.to change { user.posts.count }.from(1).to(0)
    end

    it 'allows them to delete it from their profile page' do
      visit user_path(user)

      post_content = 'This is a post from my profile page.'

      fill_in 'post_content', with: post_content
      click_on 'Post'
      
      expect(page).to have_content(post_content)
      expect(page).to have_link('delete post')

      expect { click_link 'delete post' }.to change { user.posts.count }.from(1).to(0)
    end

    it 'allows the to delete it after editing' do
      visit user_path(user)
      
      post_content = 'This is a post I will edit and then immediately delete'

      fill_in 'post_content', with: post_content
      click_on 'Post'

      expect(page).to have_link('edit post')

      click_link 'edit post'

      edited_content = 'This is an edited post that will be deleted immediately.'
      fill_in 'post_content', with: edited_content

      click_on 'Post'

      expect(page).to have_content(edited_content)
      expect(page).to have_content('delete post')

      click_link 'delete post'
      expect(page).to have_content('Post successfully removed.')
    end

    it 'redirects to the root_url' do
      visit user_path(user)

      post_content = 'This is a post from my profile page.'

      fill_in 'post_content', with: post_content
      click_on 'Post'

      click_link 'delete post'
      expect(page.current_path).to eq("/")
    end
  end
end
