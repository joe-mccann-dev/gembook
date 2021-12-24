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

    it 'allows them to delete it from the Users#index page' do
      visit user_path(user)

      post_content = 'This is my first post. Might delete later'

      fill_in 'post_content', with: post_content
      
      click_on 'Create Post'
      visit posts_path
      expect(page).to have_content(post_content)
      expect(page).to have_link('delete post')

      expect { click_link 'delete post' }.to change { user.posts.count }.from(1).to(0)
    end

    it 'allows them to delete it from their profile page' do
      visit user_path(user)

      post_content = 'This is a post from my profile page.'

      fill_in 'post_content', with: post_content
      click_on 'Create Post'
      
      expect(page).to have_content(post_content)
      expect(page).to have_link('delete post')

      expect { click_link 'delete post' }.to change { user.posts.count }.from(1).to(0)
    end
  end
end
