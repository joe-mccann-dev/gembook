require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    Rails.application.load_seed
  end

  let!(:user) { User.first }
  let!(:other_user) { User.second }
  let!(:another_user) { User.third }

  let!(:post) { user.posts.create(content: 'hey this is my first post') }
  let!(:other_post) { other_user.posts.create(content: 'yet another post') }

  let!(:post_comment) { post.comments.create(content: 'great first post', user: other_user) }
  let!(:other_post_comment) { other_post.comments.create(content: 'I agree that is yet another post', user: user) }

  let!(:profile) { user.create_profile(nickname: 'Joe smoe', bio: 'I enjoy candlelit dinners and long walks on the beach', current_city: 'New York', hometown: 'Springfield') }


  context 'notifications' do
    it 'has_many sent notifications' do
      user.sent_notifications.build
      expect(user.sent_notifications).to_not be_empty
    end

    it 'has_many received notifications' do
      user.received_notifications.build
      expect(user.received_notifications).to_not be_empty
    end
  end

  context 'friendships' do
    it 'has_many pending sent friend requests' do
      user.sent_pending_requests.build
      expect(user.sent_pending_requests).to_not be_empty
    end

    it 'has_many pending received friend requests' do
      user.received_pending_requests.build
      expect(user.received_pending_requests).to_not be_empty
    end

    it 'has_many sent accepted friend requests' do
      expect(user.sent_accepted_requests).to be_empty
      to_be_accepted = user.sent_pending_requests.create(receiver: other_user)
      to_be_accepted.accepted!
      expect(user.sent_accepted_requests).to include(to_be_accepted)
    end

    it 'has_many received accepted friend requests' do
      expect(user.received_accepted_requests).to be_empty
      to_be_accepted = user.received_pending_requests.create(sender: other_user)
      to_be_accepted.accepted!
      expect(user.received_accepted_requests).to include(to_be_accepted)
    end

    it 'has_many sent declined friend requests' do
      friendless_user = User.create(first_name: 'friendless', last_name: 'user', email: 'foo@example.com', password: 'foobar')
      to_be_declined = user.sent_pending_requests.create(sender: user, receiver: friendless_user)
      to_be_declined.declined!
      expect(user.sent_declined_requests).to include(to_be_declined)
    end

    it 'has_many received declined friend requests' do
      declined_requester = User.create(first_name: 'declined', last_name: 'requester', email: 'foo@example.com', password: 'foobar')
      to_be_declined = declined_requester.sent_pending_requests.create(sender: declined_requester, receiver: user)
      to_be_declined.declined!
      expect(user.received_declined_requests).to include(to_be_declined)
    end
  end

  context 'friends' do
    it 'has_many pending requested friends' do
      user.sent_pending_requests.create(receiver: other_user)
      expect(user.pending_requested_friends).to_not be_empty
    end

    it 'has_many pending received friends' do
      user.received_pending_requests.create(sender: other_user)
      expect(user.pending_received_friends).to_not be_empty
    end

    it 'has_many accepted requested friends' do
      future_friend = User.create(first_name: 'future', last_name: 'friend', email: 'foo@example.com', password: 'foobar')
      to_be_accepted = user.sent_pending_requests.create(sender: user, receiver: future_friend)
      to_be_accepted.accepted!
      expect(user.accepted_requested_friends).to include(future_friend)
    end

    it 'has_many accepted received friends' do
      future_friend = User.create(first_name: 'future', last_name: 'friend', email: 'foo@example.com', password: 'foobar')
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

    it 'has one profile' do
      expect(user.profile).to eq(profile)
    end
  end

  describe '.search' do
    it 'accepts a query string and returns user results' do
      expected_results = User.where(first_name: user.first_name, last_name: user.last_name)
      search_results = User.search(user.full_name)
      user = expected_results.first
      expect(search_results).to include(user)
    end
  end

  describe '#full_name' do
    it 'returns the first and last name of the user' do
      user = User.create(first_name: 'Foo', last_name: 'Bar', email: 'foo@example.com', password: 'foobar')
      expect(user.full_name).to eq('Foo Bar')
    end
  end

  describe '#current_password_required?' do
    context 'a user signed up thru the application' do
      it 'returns true' do
        user = User.create(first_name: 'Foo', last_name: 'Bar', email: 'foo@example.com', password: 'foobar')
        expect(user.current_password_required?).to eq(true) 
      end
    end

    context 'a user created an account via OAuth' do
      it 'returns false' do
        user = User.create(provider: 'github', first_name: 'bob', last_name: 'barker', email: 'bob@barker.com', password: 'foobar')
        expect(user.current_password_required?).to eq(false)
      end
    end
  end

  describe '#requests_via_sender_id' do
    context 'multiple users have sent a user a friend request' do
      context 'the requests are pending' do
        let(:receiver) { User.create(first_name: 'New', last_name: 'User', email: 'new@user.com', password: 'foobar') }
        let(:sender_one) { User.create(first_name: 'Joe', last_name: 'Smoe', email: 'joe@smoe.com', password: 'foobar') }
        let(:sender_two) { User.create(first_name: 'George', last_name: 'Washington', email: 'george@washington.com', password: 'foobar') }
        it 'returns a hash of Friendship objects mapped to the sender_id (friendship requester)' do
          sender_one.sent_pending_requests.create(receiver: receiver)
          sender_two.sent_pending_requests.create(receiver: receiver)
          first_request = receiver.received_pending_requests.first
          second_request = receiver.received_pending_requests.second
          result = { sender_one.id => first_request, sender_two.id => second_request }
          expect(receiver.requests_via_sender_id).to eq(result)
        end
      end
    end
  end

  describe '#friendships_via_friend_id' do
    context 'A user wants to know who they are friends with' do
      let(:user) { User.create(first_name: 'Joe', last_name: 'DiMaggio', email: 'joe@yankees.com', password: 'foobar') }
      let(:friend_one) { User.create(first_name: 'Mike', email: 'mike@tyson.com', password: 'foobar') }
      let(:friend_two) { User.create(first_name: 'Connor', last_name: 'McGreggor', email: 'connor@toughguy.com', password: 'foobar') }

      let(:sent_friendship) { user.sent_accepted_requests.create(receiver: friend_one, status: 'accepted') }
      let(:received_friendship) { friend_two.sent_accepted_requests.create(receiver: user, status: 'accepted') }

      it 'returns a merged hash of their accepted sent and accepted received requests' do
        result = { friend_one.id => sent_friendship, friend_two.id => received_friendship }
        expect(user.friendships_via_friend_id).to eq(result)
      end
    end
  end

  describe '#find_like' do
    context 'a user wants to unlike a likeable object' do
      let(:user) { User.create(first_name: 'Joe', last_name: 'Smoe', email: 'joe@smoe.com', password: 'foobar') }
      let(:post) { Post.create(user: user, content: 'hey this is a post') }
      it 'accepts a likeable object and returns the Like object associated with that user and likeable object' do
        user.liked_posts << post
        like = user.likes.first
        expect(user.find_like(post)).to eq(like)
      end
    end
  end
end
