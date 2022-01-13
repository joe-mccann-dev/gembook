require 'rails_helper'

RSpec.describe "PostsIndexPosts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context 'a user is on the Posts#index page' do
    before do
      login_as(user, scope: :user)
      visit posts_path
    end

    it 'allows them to post' do
      content = "Hey this is a post."
      fill_in 'post_content', with: content
      click_on 'Post'
      expect(page).to have_content(content)
      expect(page).to have_content('Post created successfully.')
    end
  end
end
