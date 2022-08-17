# README

## Gembook

A social media application programmed with Ruby on Rails.

### Installation

1. Install locally

    - Clone this repo.
    - `cd gembook`
    - `bundle install && yarn install`
    -  For proper image processing locally, on Ubuntu: `sudo apt install imagemagick`; on Mac: `brew install imagemagick`

  1. Setup the database.
      1. `rails db:create`
      2. `rails db:migrate && rails db:seed`

2. Set Up OmniAuth Authentication in Development (optional).
    - Create an OAuth app in your GitHub account for this purpose. Copy client id and secret to a figaro-gem-created and git-ignored file (`config/application.yml`)
    - Essentially, steps 1 and 2 found on my blog post: https://joe-mccann.dev/blog/setting-up-omniauth-authentication-in-development 

3. Start a Rails Server.

    - `rails server`
    - Navigate to `localhost:3000` in your browser.

4. Sign up or Login.

    - Sign up with GitHub _or_
    - Sign up with email _or_
    - Login with one of the seeded users `password: '123456'`:

        - john@example.com
        - paul@example.com
        - george@example.com
        - ringo@example.com

### Running the Specs

- `bundle exec rspec spec --format documentation`

### Features

#### Registration

- Receive a welcome email on signup (SendGrid add-on)
- Authentication via Devise _or_
- Signup/login with GitHub using OAuth2

#### Friendships

- Add other users as friends.
- "Unfriend" other users.
- Search for other users by name.
- Accept or decline friendships from Notifications page.

#### Posts

- Post text content, an image, or both.
- View your posts and friends' posts from the home page.
- Edit/Delete your posts.
- Comment on Posts.
- "Like" Posts.
- View which users "liked" a post.
- Posts are paginated with the Kaminari gem.

#### Comments

- Comment on Posts.
- Edit/Delete your comments.
- Reply to Comments (Nested Comments).
- "Like" Comments.
- Hide/show comments/replies.
- View which users "liked" a comment.

#### Notifications

- Friend requests from other users
- When a user accepts your friend requests
- When another user comments on or likes your post/comment
- Dismiss one or all notifications.

#### Profile

- Upload a profile picture.
- Create a profile with basic attributes
- Create a post from your profile page.
- View posts of friends from their profile page.
- Send/accept a friend request from a user's profile page.


### Reflection

This was a rewarding project. The initial challenge was modeling friendships, which I based around the idea of a friendship sender and receiver. Once a friendship is requested, the `Friendship` object is created with a default enumerated status of `pending` => `enum status: %i[pending accepted declined]`. When a user clicks "accept", the status is updated to 'accepted'.

Another challenge was figuring out nested comments. For this, I had to harness the power of Rails' partials, rendering the `post.comments` collection within the post partial and then recursively rendering the `comment.comments` collection within the comment partial itself. This also required setting up the `:commentable` polymorphic association on the `Comment` model. Similarly `Like` objects belong to the polymorphic association `:likeable`

One of the biggest challenges was figuring out how to send a user notifications after certain user events. I achieved this via a `NotificationsManager` module [app/lib/notifications_manager.rb](app/lib/notifications_manager.rb) and private methods within the Controllers for which a notification may be relevant. For example,

```ruby
# CommentsController
  def send_comment_notification(commented_object)
    return if commented_object.user == current_user

    send_notification({ receiver_id: commented_object.user.id,
                        object_type: 'Comment',
                        description: notification_description(commented_object),
                        time_sent: Time.zone.now.to_s,
                        object_url: determine_path(commented_object) })
  end

  # NotificationsManager
  def send_notification(args = {})
    current_user.sent_notifications.create(args)
  end
```

This `:send_notification` pattern is repeated for likes and friendships. Notification objects require the above attributes in order to facilitate showing their details on the `notifications#index` page and allowing users to view the target of the notifiation (`object_url`):

```ruby
# ApplicationController
  def determine_path(object)
    objects = {
      'Post' => post_path(object),
      'Comment' => polymorphic_path(object)
    }
    objects[object.class.to_s]
  end
```

In a previous project (Private Events), I used a service object to simultaneously invite multiple users to an event. I think the above may be a candidate for a refactor using a service object. This service object could be called in a controller's `:create` action. But I am undecided because I feel my current approach is extensible. If a future controller requires notifications be sent, I can simply apply this pattern to the new controller.

This was the largest Rails application I have coded to date. I am happy that I tested early and often, as that made making changes stress-free. I think next time, I will make system specs less fragile from the start to avoid failures on things like changing the text of a button from "Edit Profile" to "Submit Profile". For my next large project, I will also do more styling as I go along. Styling everything at once was a bit overwhelming. After getting basic functionality down, it would have been nice to only have to make small styling changes like color, padding, or font-size, rather than styling everything from scratch.
