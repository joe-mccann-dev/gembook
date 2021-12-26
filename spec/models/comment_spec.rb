require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    Rails.application.load_seed
  end

  let!(:user) { User.first }
  let!(:other_user) { User.last }
  let!(:post) { user.posts.create(content: 'this is a post') }
  let!(:comment) { post.comments.create(content: 'this is a comment on post', user: other_user) }
  let!(:comment_reply) { comment.comments.create(content: 'this is a reply to comment', user: user) }

  it 'belongs to the commentable polymorphic association' do
    expect(comment.commentable).to eq(post)
  end

  it 'has many comments as a polymorphic association' do
    expect(comment.comments).to_not be_empty
    expect(comment.comments).to include(comment_reply)
  end

  it 'can access a parent comment via polymorphic commentable association' do
    expect(comment_reply.commentable).to eq(comment)
  end

  it 'validates the presence of content' do
    empty_comment = post.comments.build(user: user, content: '')
    expect(empty_comment).to_not be_valid
  end
end
