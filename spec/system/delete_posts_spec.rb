require 'rails_helper'

RSpec.describe "DeletePosts", type: :system do
  before do
    driven_by(:selenium)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context "A user has posted something" do
    before do
      login_as(user, scope: :user)
    end

    it 'allows them to delete it from the Posts#index page' do
      visit user_path(user)

      post_content = 'This is my first post. Might delete later'

      click_on "Show Post Form"
      fill_in 'post_content', with: post_content
      
      click_on 'Post'
      visit posts_path

      expect(page).to have_content(post_content)
      expect(user.posts.count).to eq(1)

      accept_confirm do
        click_on "delete post"
      end

      expect(page).to have_no_content(post_content)
      expect(user.posts.count).to eq(0)
    end

    it 'allows them to delete it from their profile page' do
      visit user_path(user)

      post_content = 'This is a post from my profile page.'
      click_on "Show Post Form"
      fill_in 'post_content', with: post_content
      click_on 'Post'
      
      expect(page).to have_content(post_content)
      expect(user.posts.count).to eq(1)

      accept_confirm do
        click_on "delete post"
      end

      expect(page).to have_no_content(post_content)
      expect(user.posts.count).to eq(0)
    end
  end
end
