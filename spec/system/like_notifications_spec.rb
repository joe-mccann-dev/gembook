require 'rails_helper'

include UsersHelper

RSpec.describe 'LikeNotifications', type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'john', last_name: 'smith', email: 'john@smith.com', password: 'foobar') }
  let!(:friendship) { Friendship.create(sender: user, receiver: other_user) }
  let!(:post) { user.posts.create(content: "hey this is #{user.first_name}") }
  let!(:comment) { post.comments.create(user: other_user, content: 'great post!') }


  context "A user logs in, sees their friend's post, and 'likes' it" do
    before do
      login_as(other_user, scope: :user)
      friendship.accepted!
      visit posts_path
    end

    it "allows the user to 'like' the post" do
      expect { find("#post-#{post.id}-like").click }.to change { post.likes.count }.from(0).to(1)
    end

    it 'sends the author of the post a notification' do
      expect { find("#post-#{post.id}-like").click }.to change { user.received_notifications.count }.from(0).to(1)
    end

    it "allows the author of the post to see their 'user liked your post' notfication" do
      find("#post-#{post.id}-like").click

      logout(other_user, scope: :user)
      login_as(user, scope: :user)
      visit notifications_path
      expect(page).to have_content("#{other_user.full_name}")
      expect(page).to have_link('liked your post')
    end

    it 'allows the user to click on a link to the original post' do
      find("#post-#{post.id}-like").click

      logout(other_user, scope: :user)
      login_as(user, scope: :user)
      visit notifications_path
      expect(page).to have_content("#{other_user.full_name}")
      expect(page).to have_link('liked your post')
      click_link('liked your post')
      expect(current_path).to eq(post_path(post))
    end
  end

  context 'A user logs in and wants to like a comment' do
    before do
      login_as(user, scope: :user)
      friendship.accepted!
      visit posts_path
    end
    
    it "allows the user to 'like' the post" do
      expect { find("#comment-#{comment.id}-like").click }.to change { comment.likes.count }.from(0).to(1)
    end

    it 'sends the author of the comment a notification' do
      expect { find("#comment-#{comment.id}-like").click }.to change { other_user.received_notifications.count }.from(0).to(1)
    end

    it "allows the author of the post to see their 'user liked your comment' notfication" do
      find("#comment-#{comment.id}-like").click

      logout(user, scope: :user)
      login_as(other_user, scope: :user)
      visit notifications_path

      expect(page).to have_content("#{user.full_name}")
      expect(page).to have_link('liked your comment')
    end

    it 'allows the user to click on a link to the original comment' do
      find("#comment-#{comment.id}-like").click

      logout(user, scope: :user)
      login_as(other_user, scope: :user)
      visit notifications_path

      expect(page).to have_content("#{user.full_name}")
      expect(page).to have_link('liked your comment')
      click_link('liked your comment')
      expect(current_path).to eq(comment_path(comment))
    end
  end
end
