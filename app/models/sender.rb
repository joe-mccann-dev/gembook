class Sender < User
  has_many :friendships, as: :friendable
end