class Receiver < User
  has_many :friendships, as: :friendable
end