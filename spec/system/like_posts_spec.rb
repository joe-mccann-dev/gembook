require 'rails_helper'

include UsersHelper

RSpec.describe "LikePosts", type: :system do
  before do
    driven_by(:selenium)
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
      visit posts_path
    end

    it 'allows a user to like a post' do
      expect(liker.liked_posts.count).to eq(0)

      find("#post-#{post.id}-like").click
      find(".thumb-filled");
      
      expect(post.likers.count).to eq(1)
    end

    it 'allows a user to like their own post' do
      expect(user.liked_posts.count).to eq(0)
      logout(liker)
      login_as(user, scope: :user)

      find("#post-#{post.id}-like").click
      find(".thumb-filled");

      expect(user.liked_posts.count).to eq(1)
      expect(post.likers.count).to eq(1)
    end

    it 'allows more than one user to like a post' do
      expect(liker.liked_posts.count).to eq(0)
      find("#post-#{post.id}-like").click
      find(".thumb-filled")
      expect(liker.liked_posts.count).to eq(1)

      expect(post.likers.count).to eq(1)

      logout(liker)
      login_as(user, scope: :user)
      visit posts_path

      expect(user.liked_posts.count).to eq(0)
      find("#post-#{post.id}-like").click
      find(".thumb-filled")
      expect(user.liked_posts.count).to eq(1)

      expect(post.likers.count).to eq(2)
    end

    it 'shows unlike version of like button after liking' do
      expect(page).to have_css("#post-#{post.id}-like")
      find("#post-#{post.id}-like").click
      expect(page).to have_css("#post-#{post.id}-unlike")
    end

    it 'shows like count after liking' do
      find("#post-#{post.id}-like").click
      find(".thumb-filled")
      liker_name = post.likers.first.full_name
      expect(page).to have_content("1 like")
    end
  end
end
