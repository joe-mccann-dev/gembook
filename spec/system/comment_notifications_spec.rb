require 'rails_helper'
include UsersHelper

RSpec.describe "CommentNotifications", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'Foo', last_name: 'Bar', email: 'foo@bar.com', password: 'password') }
  let!(:other_user) { User.create(first_name: 'John', last_name: 'Smith', email: 'john@smith.com', password: 'password') }
  let!(:friendship) { Friendship.create(sender: user, receiver: other_user) }
  let!(:post) { user.posts.create(content: 'this is a user post') }

  context "A user comments on a friend's post" do
    before do
      login_as(other_user, scope: :user)
      friendship.accepted!
      visit posts_path
    end

    it 'sends the owner of the post a notification' do
      # button to display comment form has 'Comment' or 'Reply' followed by id of the commentable object
      find("#Comment-#{post.id}").click
      fill_in "post-#{post.id}-comment", with: "Hey great post Mr. User!"
      expect { find("#submit-#{post.id}").click }.to change { user.received_notifications.count }.from(0).to(1)
    end
  end

  context "A user replies to a comment" do

    before do
      login_as(other_user, scope: :user)
      friendship.accepted!
      visit posts_path
    end

    it 'sends the owner of the comment a notification' do
      fill_in "post-#{post.id}-comment", with: "Hey great post Mr. User!"
      find("#submit-#{post.id}").click

      logout(other_user)
      login_as(user, scope: :user)
      visit posts_path

      post_comment = post.comments.first
      find("#Reply-#{post_comment.id}").click
      fill_in "post-#{post.id}-comment-#{post_comment.id}-reply", with: "What a great comment Mr. Other User!"
      expect { find("#submit-#{post_comment.id}").click }.to change { other_user.received_notifications.count }.from(0).to(1)
    end

    it 'allows the user to view their notification and click on a link to the original post comment' do
      find("#Comment-#{post.id}").click
      fill_in "post-#{post.id}-comment", with: "Hey great post Mr. User!"
      find("#submit-#{post.id}").click

      logout(other_user)
      login_as(user, scope: :user)
      visit notifications_path
      expect(page).to have_content("#{other_user.full_name}")
      expect(page).to have_link('commented on your post')
      click_link('commented on your post')
      expect(current_path).to eq(post_path(post))
    end
  end
end
