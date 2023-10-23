require 'rails_helper'

RSpec.describe "ViewPostsAndComments", type: :system do
  before do
    driven_by(:selenium)
  end

  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'john', last_name: 'smith', email: 'john@smith.com', password: 'foobar') }
  let!(:friendship) { Friendship.create(sender: user, receiver: other_user) }

  let!(:post) { user.posts.create(content: "hey this is #{user.first_name}") }
  let!(:other_post) { other_user.posts.create(content: "hey this is #{other_user.first_name}") }

  let!(:comment) { post.comments.create(user: other_user, content: 'great post!') }
  let!(:other_comment) { post.comments.create(user: user, content: 'comment by user')}

  context "A user manually enters a url to a specific post" do
    before do
      login_as(user, scope: :user)
    end

    it 'allows a user to view the posts#show path of a post they own' do
      visit post_path(post)
      expect(page).to have_content(post.content)
    end

    it "allows a user to view the posts#show path of a friend's post" do
      friendship.accepted!
      # logged in as user, going to view other_user's post after accepting friendship
      visit post_path(other_post)
      expect(page).to have_content(other_post.content)
    end

    it 'does not allow a user to view the posts#show path of a post unless they are friends' do
      visit post_path(other_post)
      expect(page).to have_content('You must be friends with the author to view this post')
      expect(current_path).to eq(root_path)

      friendship.accepted!
      visit post_path(other_post)
      expect(page).to have_content(other_post.content)
    end
  end

  context "A user manually enters a url to a specific comment" do
    before do
      login_as(other_user, scope: :user)
    end

    it 'allows a user to view the comments#show path of a comment they own' do
      visit comment_path(comment)
      expect(page).to have_content(comment.content)
    end

    it "allows a user to view the comments#show path of a friend's comment" do
      friendship.accepted!
      # logged in as user, going to view other_user's post after accepting friendship
      visit comment_path(comment)
      expect(page).to have_content(comment.content)
    end

    it 'does not allow a user to view the comments#show path of a comment unless they are friends' do
      visit comment_path(other_comment)
      expect(page).to have_content('You must be friends with the author to view this comment')
      expect(current_path).to eq(root_path)

      friendship.accepted!
      visit comment_path(other_comment)
      expect(page).to have_content(other_comment.content)
    end
  end
end
