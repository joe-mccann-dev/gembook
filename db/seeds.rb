# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
foo = User.create(first_name: 'Foo', last_name: 'Bar', email: 'foo@bar.com', password: 'foobar')
john = User.create(first_name: 'John', last_name: 'Smith', email: 'john@smith.com', password: 'foobar')
jane = User.create(first_name: 'Jane', last_name: 'Doe', email: 'jane@doe.com', password: 'foobar')
bob = User.create(first_name: 'Bob', last_name: 'Barker', email: 'bob@barker.com', password: 'foobar')
ziggy = User.create(first_name: 'Ziggy', last_name: 'Stardust', email: 'ziggy@stardust.com', password: 'foobar')

users = [foo, john, jane, bob, ziggy]

users.reject { |u| u == foo || u == john }.each_with_index do |user, index|
  friendship = foo.sent_pending_requests.build(sender: foo, receiver: user)
  friendship.save
  notification = foo.sent_notifications.build(receiver: user,
                                              object_type: 'Friendship',
                                              description: 'new friend request',
                                              time_sent: (Time.zone.now + index).to_s,
                                              object_url: Rails.application.routes.url_helpers.users_path)
  notification.save
end

friendship = john.sent_pending_requests.build(sender: john, receiver: foo)
friendship.save
notification = john.sent_notifications.build(receiver: foo,
                                             object_type: 'Friendship',
                                             description: 'new friend request',
                                             time_sent: Time.zone.now.to_s,
                                             object_url: Rails.application.routes.url_helpers.users_path)
notification.save
