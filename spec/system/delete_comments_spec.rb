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
      find("#Comment-#{post.id}").click
      fill_in "post-#{post.id}-comment", with: comment_content
      find("#submit-#{post.id}").click

      expect(page).to have_content(comment_content)
      expect(page).to have_link('delete')

      expect { click_link 'delete' }.to change { user.comments.count }.from(1).to(0)
    end

    it 'allows them to delete it from the Users#show page' do
      visit user_path(user)
      post_content = 'This is a post that will be commented on.'
  
      fill_in 'post_content', with: post_content
      
      click_on 'Post'
      post = user.posts.first

      comment_content = 'This is that comment that I promised.'
      find("#Comment-#{post.id}").click
      fill_in "post-#{post.id}-comment", with: comment_content
      find("#submit-#{post.id}").click

      expect(page).to have_content(comment_content)
      expect(page).to have_link('delete')

      expect { click_link 'delete' }.to change { user.comments.count }.from(1).to(0)
    end
  end
end
