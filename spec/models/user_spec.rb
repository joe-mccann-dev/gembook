require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    Rails.application.load_seed
  end
  context 'notifications' do
    it 'has_many sent notifications' do
      expect(User.first.sent_notifications).to_not be_empty
    end

    it 'has_many received notifications' do
      expect(User.first.received_notifications).to_not be_empty
    end
  end

  context 'friendships' do
    it 'has_many pending sent friend requests' do
      expect(User.first.sent_pending_requests).to_not be_empty
    end

    it 'has_many pending received friend requests' do
      expect(User.first.received_pending_requests).to_not be_empty
    end

    it 'has_many sent accepted friend requests' do
      expect(User.first.sent_accepted_requests).to be_empty
      to_be_accepted = User.first.sent_pending_requests.first
      to_be_accepted.accepted!
      expect(User.first.sent_accepted_requests).to include(to_be_accepted)
    end

    it 'has_many received accepted friend requests' do
      expect(User.first.received_accepted_requests).to be_empty
      to_be_accepted = User.first.received_pending_requests.first
      to_be_accepted.accepted!
      expect(User.first.received_accepted_requests).to include(to_be_accepted)
    end

    it 'has_many sent declined friend requests' do
      friendless_user = User.create(first_name: 'friendless', last_name: 'user', email: 'foo@bar.com', password: 'foobar')
      to_be_declined = User.first.sent_pending_requests.create(sender: User.first, receiver: friendless_user)
      to_be_declined.declined!
      expect(User.first.sent_declined_requests).to include(to_be_declined)
    end

    it 'has_many received declined friend requests' do
      declined_requester = User.create(first_name: 'declined', last_name: 'requester', email: 'foo@bar.com', password: 'foobar')
      to_be_declined = declined_requester.sent_pending_requests.create(sender: declined_requester, receiver: User.first)
      to_be_declined.declined!
      expect(User.first.received_declined_requests).to include(to_be_declined)
    end
  end

  context 'friends' do
    it 'has_many pending requested friends' do
      expect(User.first.pending_requested_friends).to_not be_empty
    end

    it 'has_many pending received friends' do
      expect(User.first.pending_received_friends).to_not be_empty
    end

    it 'has_many accepted requested friends' do
      future_friend = User.create(first_name: 'future', last_name: 'friend', email: 'foo@bar.com', password: 'foobar')
      to_be_accepted = User.first.sent_pending_requests.create(sender: User.first, receiver: future_friend)
      to_be_accepted.accepted!
      expect(User.first.accepted_requested_friends).to include(future_friend)
    end

    it 'has_many accepted received friends' do
      future_friend = User.create(first_name: 'future', last_name: 'friend', email: 'foo@bar.com', password: 'foobar')
      to_be_accepted = future_friend.sent_pending_requests.create(sender: future_friend, receiver: User.first)
      to_be_accepted.accepted!
      expect(User.first.accepted_received_friends).to include(future_friend)
    end
  end

  context 'posts' do
    it 'has_many posts' do
      post = User.first.posts.build(content: 'hey this is my first post')
      post.save
      expect(User.first.posts).to_not be_empty
    end
  end

  context 'likes' do
    it 'has_many likes' do
      post = User.first.posts.build(content: 'another post')
      post.save
      post_liker = User.second
      post.likes.create(user: post_liker)
      expect(post_liker.likes.count).to eq(1)

      other_post = User.first.posts.build(content: 'yet another post')
      other_post.save
      other_post.likes.create(user: post_liker)
      expect(post_liker.likes.count).to eq(2)
    end
  end
end
