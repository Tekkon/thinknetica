require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 2) }
    let(:mail) { DailyMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["thinknetica-dev@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include(questions.first.title)
      expect(mail.body.encoded).to include(questions.last.title)
    end
  end
end
