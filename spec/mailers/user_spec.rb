require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:user) { User.create(first_name: 'foo', last_name: 'bar', email: 'foo@bar.com', password: 'foobar') }
  let!(:mail) { UserMailer.welcome_email(user) }

  it "renders the subject" do
    expect(mail.subject).to eq("Welcome to Gembook.")
  end

  it "renders the recipient email" do
    expect(mail.to).to eq([user.email])
  end

  it "renders the sender email" do
    expect(mail.from).to eq(["joe.mccann.dev@gmail.com"])
  end

  it "includes the user's name" do
    expect(mail.body.encoded).to include(user.full_name)
  end
end
