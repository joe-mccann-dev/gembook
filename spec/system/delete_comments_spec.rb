require 'rails_helper'

RSpec.describe "DeleteComments", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context 'a user has commented on something' do
    before do
      login_as(user, scope: :user)
    end
  
    it 'allows them to delete it from the Posts#index page' do
      visit user_path(user)
      post_content = 'This is a post that will be commented on.'
  
      fill_in 'post_content', with: post_content
      
      click_on 'Post'
      visit posts_path
      post = user.posts.first

      comment_content = 'This is that comment that I promised.'
      fill_in "post-#{post.id}-comment", with: comment_content
      click_on 'Comment'

      expect(page).to have_content(comment_content)
      expect(page).to have_link('delete comment')

      expect { click_link 'delete comment' }.to change { user.comments.count }.from(1).to(0)
    end

    it 'allows them to delete it from the Users#show page' do
      visit user_path(user)
      post_content = 'This is a post that will be commented on.'
  
      fill_in 'post_content', with: post_content
      
      click_on 'Post'
      post = user.posts.first

      comment_content = 'This is that comment that I promised.'
      fill_in "post-#{post.id}-comment", with: comment_content
      click_on 'Comment'

      expect(page).to have_content(comment_content)
      expect(page).to have_link('delete comment')

      expect { click_link 'delete comment' }.to change { user.comments.count }.from(1).to(0)
    end

    it 'allows the to delete it after editing' do
      visit user_path(user)
      
      post_content = 'This is a post I will edit and then immediately delete'

      fill_in 'post_content', with: post_content
      click_on 'Post'

      post = user.posts.first

      comment_content = 'This is a comment that will be edited.'
      fill_in "post-#{post.id}-comment", with: comment_content
      click_on 'Comment'

      click_link 'edit comment'
      edited_comment = "#{comment_content} some additional text"
      fill_in "post-#{post.id}-comment", with: edited_comment
      click_on 'Comment'

      comment = post.comments.first
      expect { click_link 'delete comment' }.to change { post.comments.count }.from(1).to(0)
      expect(user.comments.count).to eq(0)
    end

    it 'redirects to the path of the commentable object.' do
      visit user_path(user)

      post_content = 'This is a post from my profile page.'

      fill_in 'post_content', with: post_content
      click_on 'Post'

      post = user.posts.first

      comment_content = 'This is a comment that will be edited.'
      fill_in "post-#{post.id}-comment", with: comment_content
      click_on 'Comment'

      click_link 'delete comment'
      expect(page.current_path).to eq(post_path(post))
    end
  end
end
