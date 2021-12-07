require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    Rails.application.load_seed
  end

  let!(:user) { User.first }
  let!(:other_user) { User.second }

  let!(:post) { user.posts.create(content: 'hey this is my first post') }
  let!(:other_post) { other_user.posts.create(content: 'yet another post') }

  let!(:post_comment) { post.comments.create(content: 'great first post', user: other_user) }
  let!(:other_post_comment) { other_post.comments.create(content: 'I agree that is yet another post', user: user) }

  context 'notifications' do
    it 'has_many sent notifications' do
      expect(user.sent_notifications).to_not be_empty
    end

    it 'has_many received notifications' do
      expect(user.received_notifications).to_not be_empty
    end
  end

  context 'friendships' do
    it 'has_many pending sent friend requests' do
      expect(user.sent_pending_requests).to_not be_empty
    end

    it 'has_many pending received friend requests' do
      expect(user.received_pending_requests).to_not be_empty
    end

    it 'has_many sent accepted friend requests' do
      expect(user.sent_accepted_requests).to be_empty
      to_be_accepted = user.sent_pending_requests.first
      to_be_accepted.accepted!
      expect(user.sent_accepted_requests).to include(to_be_accepted)
    end

    it 'has_many received accepted friend requests' do
      expect(user.received_accepted_requests).to be_empty
      to_be_accepted = user.received_pending_requests.first
      to_be_accepted.accepted!
      expect(user.received_accepted_requests).to include(to_be_accepted)
    end

    it 'has_many sent declined friend requests' do
      friendless_user = User.create(first_name: 'friendless', last_name: 'user', email: 'foo@bar.com', password: 'foobar')
      to_be_declined = user.sent_pending_requests.create(sender: user, receiver: friendless_user)
      to_be_declined.declined!
      expect(user.sent_declined_requests).to include(to_be_declined)
    end

    it 'has_many received declined friend requests' do
      declined_requester = User.create(first_name: 'declined', last_name: 'requester', email: 'foo@bar.com', password: 'foobar')
      to_be_declined = declined_requester.sent_pending_requests.create(sender: declined_requester, receiver: user)
      to_be_declined.declined!
      expect(user.received_declined_requests).to include(to_be_declined)
    end
  end

  context 'friends' do
    it 'has_many pending requested friends' do
      expect(user.pending_requested_friends).to_not be_empty
    end

    it 'has_many pending received friends' do
      expect(user.pending_received_friends).to_not be_empty
    end

    it 'has_many accepted requested friends' do
      future_friend = User.create(first_name: 'future', last_name: 'friend', email: 'foo@bar.com', password: 'foobar')
      to_be_accepted = user.sent_pending_requests.create(sender: user, receiver: future_friend)
      to_be_accepted.accepted!
      expect(user.accepted_requested_friends).to include(future_friend)
    end

    it 'has_many accepted received friends' do
      future_friend = User.create(first_name: 'future', last_name: 'friend', email: 'foo@bar.com', password: 'foobar')
      to_be_accepted = future_friend.sent_pending_requests.create(sender: future_friend, receiver: user)
      to_be_accepted.accepted!
      expect(user.accepted_received_friends).to include(future_friend)
    end
  end

  context 'posts' do
    it 'has_many posts' do
      expect(user.posts).to_not be_empty
    end
  end

  context 'likes' do
    it 'has_many likes' do
      post.likes.create(user: other_user)
      expect(other_user.likes.count).to eq(1)

      other_post.likes.create(user: other_user)
      expect(other_user.likes.count).to eq(2)
    end

    it 'has_many comments' do
      expect(other_user.comments).to_not be_empty
    end

    it 'has_many liked posts' do
      post.likes.create(user: other_user)
      other_post.likes.create(user: other_user)
      expect(other_user.liked_posts.count).to eq(2)
    end

    it 'has_many liked_comments' do
      post_comment.likes.create(user: user)
      other_post_comment.likes.create(user: user)
      expect(user.liked_comments.count).to eq(2)
    end
  end
end
