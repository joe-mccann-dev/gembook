require 'rails_helper'

RSpec.describe Notification, type: :model do
  before do
    Rails.application.load_seed
  end

  let(:sender) { User.first }
  let(:receiver) { User.create(first_name: 'friendship', last_name: 'receiver', email: 'foo@example.com', password: 'foobar') }

  it 'belongs to the receiver of the notification' do
    notification = sender.sent_notifications.create(receiver_id: receiver.id, object_type: 'Friendship', description: 'new friend request', time_sent: Time.zone.now)
    expect(notification.sender).to eq(sender)
  end

  it 'belongs to the sender of the notification' do
    notification = sender.sent_notifications.create(receiver_id: receiver.id, object_type: 'Friendship', description: 'new friend request', time_sent: Time.zone.now)
    expect(notification.receiver).to eq(receiver)
  end

  it 'has a default read boolean set to false' do
    notification = sender.sent_notifications.create(receiver_id: receiver.id, object_type: 'Friendship', description: 'new friend request', time_sent: Time.zone.now)
    expect(notification.read).to eq(false)
  end
end
