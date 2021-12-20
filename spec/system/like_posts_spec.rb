require 'rails_helper'

include UsersHelper

RSpec.describe "LikePosts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'Foo', last_name: 'Bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:liker) { User.create(first_name: 'Post', last_name: 'Liker', email: 'post@liker.com', password: 'foobar') }
  let!(:another_user) { User.create(first_name: 'Another', last_name: 'User', email: 'another@user.com', password: 'foobar') }
  let!(:friendship) { Friendship.create(sender: user, receiver: liker) }
  let!(:another_friendship) { Friendship.create(sender: user, receiver: another_user)}
  let!(:post) { user.posts.create(content: 'hey this is a post.') }

  context 'The user is signed in and ready to like a post by user' do
  
    before do
      login_as(liker, scope: :user)
      friendship.accepted!
      another_friendship.accepted!
      visit root_url
    end

    it 'allows a user to like a post' do
      expect { find("#post-#{post.id}-like").click }.to change { liker.liked_posts.count }.from(0).to(1)
      expect(post.likers.count).to eq(1)
    end

    it 'allows a user to like their own post' do
      logout(liker)
      login_as(user, scope: :user)
      expect { find("#post-#{post.id}-like").click }.to change { user.liked_posts.count }.from(0).to(1)
      expect(post.likers.count).to eq(1)
    end

    it 'allows more than one user to like a post' do
      expect { find("#post-#{post.id}-like").click }.to change { liker.liked_posts.count }.from(0).to(1)
      expect(post.likers.count).to eq(1)

      logout(liker)
      login_as(user, scope: :user)
      visit root_url

      expect { find("#post-#{post.id}-like").click }.to change { user.liked_posts.count }.from(0).to(1)
      expect(post.likers.count).to eq(2)
    end

    it 'shows unlike version of like button after liking' do
      expect(page).to have_css("#post-#{post.id}-like")
      find("#post-#{post.id}-like").click
      expect(page).to have_css("#post-#{post.id}-unlike")
    end

    it 'shows who liked the post after clicking like' do
      find("#post-#{post.id}-like").click
      liker_name = full_name(post.likers.first)
      expect(page).to have_content("#{liker_name} likes this.")
    end

    it 'shows full names of two users if two users like a post' do
      find("#post-#{post.id}-like").click
      expect(page).to have_content("#{full_name(liker)} likes this.")

      logout(liker)
      login_as(user, scope: :user)
      visit root_url

      find("#post-#{post.id}-like").click
      expect(page).to have_content("#{full_name(liker)} and #{full_name(user)} like this.")
    end

    it 'shows first liker and how many others have liked a post if like count is greater than 2' do
      find("#post-#{post.id}-like").click
      expect(page).to have_content("#{full_name(liker)} likes this.")

      logout(liker)
      login_as(user, scope: :user)
      visit root_url

      find("#post-#{post.id}-like").click
      expect(page).to have_content("#{full_name(liker)} and #{full_name(user)} like this.")

      logout(user)
      login_as(another_user)
      visit root_url

      find("#post-#{post.id}-like").click
      expect(page).to have_content("#{full_name(liker)} and 2 others like this.")
    end
  end
end
