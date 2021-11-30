# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
joe = User.create(first_name: 'Joe', last_name: 'McCann', email: 'joe.mccann@mailbox.org', password: 'foobar')
john = User.create(first_name: 'John', last_name: 'Smith', email: 'john@smith.com', password: 'foobar')
jane = User.create(first_name: 'Jane', last_name: 'Doe', email: 'jane@doe.com', password: 'foobar')
bob = User.create(first_name: 'Bob', last_name: 'Barker', email: 'bob@barker.com', password: 'foobar')
ziggy = User.create(first_name: 'Ziggy', last_name: 'Stardust', email: 'ziggy@stardust.com', password: 'foobar')

users = [joe, john, jane, bob, ziggy]

users.each do |user|
  friendship = joe.sent_pending_requests.build(sender: joe, receiver: user)
  friendship.save
  notification = joe.sent_notifications.build(receiver: user,
                                              object_type: 'Friendship',
                                              description: 'friend request')
  notification.save
end
