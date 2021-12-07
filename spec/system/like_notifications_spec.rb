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

      expect(page).to have_content("#{full_name(other_user)} liked your post.")
    end
  end
end