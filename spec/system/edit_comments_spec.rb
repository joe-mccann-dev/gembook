require 'rails_helper'

RSpec.describe "EditComments", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context 'a user wants to edit their comment' do
    before do
      login_as(user, scope: :user)
    end

    it 'allows the to edit their comment from Posts#index' do
      visit user_path(user)
      post_content = 'This is a post that I will comment on later'

      fill_in 'post_content', with: post_content
      click_on 'Post'
      

      post = user.posts.first
      expect(page.current_path).to eq(user_path(user))

      comment_content = 'This is that comment that I promised.'
      fill_in "post-#{post.id}-comment", with: comment_content
      click_on 'Comment'
      expect(page.current_path).to eq(user_path(user))
      expect(page).to have_link('edit')

      click_link 'edit'
      comment_box = "post-#{post.id}-comment"
      comment = 'this is an edited comment'
      
      fill_in comment_box, with: comment
      click_on 'Comment'
      expect(page).to have_content(comment)
    end

    it 'allows the user to edit their comment from the Users#show page.' do
      visit user_path(user)
      post_content = 'This is a post that I will comment on later'

      fill_in 'post_content', with: post_content
      click_on 'Post'
      expect(page.current_path).to eq(user_path(user))

      visit posts_path
      post = user.posts.first

      comment_content = 'This is that comment that I promised.'
      fill_in "post-#{post.id}-comment", with: comment_content
      click_on 'Comment'
      expect(page).to have_link('edit')

      click_link 'edit'
      comment_box = "post-#{post.id}-comment"
      comment = 'this is an edited comment'

      fill_in comment_box, with: comment
      click_on 'Comment'
      expect(page).to have_content(comment)
    end
  end
end
