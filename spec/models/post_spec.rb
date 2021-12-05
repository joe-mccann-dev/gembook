require 'rails_helper'

RSpec.describe Post, type: :model do

  let!(:user) { User.create(first_name: 'john', last_name: 'smith', email: 'john@smith.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'other', last_name: 'user', email: 'other@user.com', password: 'foobar') }
  let!(:post) { user.posts.create(content: 'this is a post') }

  it 'belongs to the user author of a post' do
    expect(post.user).to eq(user)
  end

  it 'has_many likes' do
    post_liker = other_user
    post.likes.create(user: post_liker)
    expect(post.likes).to_not be_empty
  end

  it 'has_many likers' do
    post_liker_one = user
    post_liker_two = other_user
    post.likes.create(user: post_liker_one)
    post.likes.create(user: post_liker_two)
    expect(post.likers.count).to eq(2)
  end

  it 'allows multiple users to like the same post' do
    post_liker = other_user
    post.likes.create(user: post_liker)
    post.likes.create(user: user)
    expect(post.likes.count).to eq(2)
  end
end
