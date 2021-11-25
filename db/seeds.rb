# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
joe = User.create(first_name: 'Joe', last_name: 'McCann', email: 'joe.mccann@mailbox.org', password: 'foobar')
john = User.create(first_name: 'John', last_name: 'Smith', email: 'john@smith.com', password: 'foobar')
