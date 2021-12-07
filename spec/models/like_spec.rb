require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { User.create(first_name: 'Joe', last_name: 'Schmoe', email: 'joe@schmoe.com', password: 'foobar') }
  let!(:post_liker) { User.create(first_name: 'Bart', last_name: 'Simpson', email: 'bart@simpson.com', password: 'foobar') }
  let!(:post) { user.posts.create(content: 'This is a post by Joe Schmoe. It is not interesting.') }
  let!(:like) { post.likes.create(user: post_liker) }

  it 'belongs to a post' do
    expect(like.likeable).to eq(post)
  end

  it 'belongs to a user' do
    expect(like.user).to eq(post_liker)
  end

  it 'Should raise an error when a duplicate like from the same user is attempted' do
    duplicate_like = post.likes.build(user: post_liker)
    expect { duplicate_like.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
