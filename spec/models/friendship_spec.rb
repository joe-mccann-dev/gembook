require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before do
    Rails.application.load_seed
  end
  
  let(:sender) { User.first }
  let(:receiver) { User.create(first_name: 'friendship', last_name: 'receiver', email: 'foo@bar.com', password: 'foobar') }

  it 'belongs to the sender of the request' do
    friendship = Friendship.create(sender: sender, receiver: receiver)
    expect(friendship.sender).to eq(sender)
  end

  it 'belongs to the receiver of the request' do
    friendship = Friendship.create(sender: sender, receiver: receiver)
    expect(friendship.receiver).to eq(receiver)
  end

  it 'has a default status of pending' do
    friendship = Friendship.create(sender: sender, receiver: receiver)
    expect(friendship.status).to eq('pending')
  end
end
