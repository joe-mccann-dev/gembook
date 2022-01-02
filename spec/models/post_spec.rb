require 'rails_helper'

RSpec.describe Post, type: :model do

  let!(:user) { User.create(first_name: 'john', last_name: 'smith', email: 'john@smith.com', password: 'foobar') }
  let!(:other_user) { User.create(first_name: 'other', last_name: 'user', email: 'other@user.com', password: 'foobar') }
  let!(:post) { user.posts.create(content: 'this is a post') }
  let!(:comment) { post.comments.create(content: 'this is a comment on a post', user: other_user) }

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

  it 'has many comments as the commentable association' do
    expect(post.comments).to include(comment)
    expect(comment.commentable).to eq(post)
  end

  describe 'Validations' do

    context 'a post without an image' do
      it 'validates the presence of content' do
        empty_post = user.posts.build(content: '')
        expect(empty_post).to_not be_valid
      end
    end

    context 'a post without content' do
      it 'validates an image is attached to the post object' do
        post_without_content = user.posts.build(content: '')
        image_file_path = "#{Rails.root}/spec/files/image_1.jpg"
        filename = File.basename(image_file_path)
        post_without_content.image.attach(io: File.open(image_file_path), filename: filename)
        expect(post_without_content).to be_valid
      end
    end

    context 'a post without an image' do
      it 'validates content is present' do
        post_without_image = user.posts.build(content: 'hey')
        expect(post_without_image).to be_valid
      end
    end
  end
end
