require 'rails_helper'

RSpec.describe Post, type: :model do

  before do
    Rails.application.load_seed
  end

  it 'belongs to the user author of a post' do
    post = User.first.posts.build(content: 'this is a post')
    post.save
    expect(post.user).to eq(User.first)
  end
end
