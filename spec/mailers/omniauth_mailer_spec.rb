require "rails_helper"

RSpec.describe OmniauthMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:mail) { described_class.finish_signup_email(user.id, 'new@email.com').deliver_now }

  describe '#finish_signup_email' do
    it 'renders the subject' do
      expect(mail.subject).to eq('Email confirmation')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(['new@email.com'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['thinknetica-dev@example.com'])
    end

    it 'assigns @id' do
      expect(mail.body.encoded).to match(user.id.to_s)
    end

    it 'assigns @email' do
      expect(URI.unescape(mail.body.encoded)).to match('new@email.com')
    end

    it 'assigns confirmation url' do
      expect(URI.unescape(mail.body.encoded)).to include("http://localhost:3000/users/#{user.id}/finish_signup?email=new@email.com")
    end
  end
end
