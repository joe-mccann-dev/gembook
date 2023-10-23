require 'rails_helper'

RSpec.describe "DeleteComments", type: :system do
  before do
    driven_by(:selenium)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }

  context 'a user has commented on something' do
    before do
      login_as(user, scope: :user)
    end
  
    it 'allows them to delete it from the Posts#index page' do
      visit user_path(user)
      post_content = 'This is a post that will be commented on.'

      click_on 'Show Post Form'
      fill_in 'post_content', with: post_content
      
      click_on 'Post'
      visit posts_path
      post = user.posts.first

      comment_content = 'This is that comment that I promised.'
      find("#Comment-#{post.id}").click
      fill_in "post-#{post.id}-comment", with: comment_content
      find("#submit-#{post.id}").click

      expect(page).to have_content(comment_content)

      expect { user.comments.count.to eq(1) }

      expect(page).to have_button('delete comment')

      accept_confirm do
        click_on 'delete comment'
      end

      expect { user.comments.count.to eq(0) }
    end

    it 'allows them to delete it from the Users#show page' do
      visit user_path(user)
      post_content = 'This is a post that will be commented on.'

      click_on 'Show Post Form'
      fill_in 'post_content', with: post_content
      
      click_on 'Post'
      post = user.posts.first

      comment_content = 'This is that comment that I promised.'
      click_on "Comment"

      find(".comment-box", wait: 10).fill_in with: comment_content
      click_on "Comment on Post"

      expect(page).to have_content(comment_content)

      expect { user.comments.count.to eq(1) }

      expect(page).to have_button('delete comment')

      accept_confirm do
        click_on 'delete comment'
      end

      expect { user.comments.count.to eq(0) }
    end
  end
end
