require 'rails_helper'

include UsersHelper

RSpec.describe "ViewLikers", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create(first_name: 'Foo', last_name: 'Bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:liker) { User.create(first_name: 'Post', last_name: 'Liker', email: 'post@liker.com', password: 'foobar') }
  let!(:another_user) { User.create(first_name: 'Another', last_name: 'User', email: 'another@user.com', password: 'foobar') }
  let!(:friendship) { Friendship.create(sender: user, receiver: liker) }
  let!(:another_friendship) { Friendship.create(sender: user, receiver: another_user)}
  let!(:post) { user.posts.create(content: 'hey this is a post.') }

  context 'a post has been liked by several people and a user wants to see who liked it' do
    before do
      login_as(user, scope: :user)
      visit root_url
      friendship.accepted!
      another_friendship.accepted!

      find("#post-#{post.id}-like").click
      
      logout(user)
      login_as(liker, scope: :user)
      visit root_url

      find("#post-#{post.id}-like").click

      logout(liker)
      login_as(another_user)
      visit root_url

      find("#post-#{post.id}-like").click
    end

    it 'allows the user to see who else has liked the post' do
      click_link("3 likes")
      visit post_path(post)

      expect(page).to have_content("#{user.full_name}")
      expect(page).to have_content("#{liker.full_name}")
      expect(page).to have_content("#{another_user.full_name}")
    end
  end
end
