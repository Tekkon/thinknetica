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

  describe 'question_update' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }
    let(:mail) { DailyMailer.question_update(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Question update")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["thinknetica-dev@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include(answer.user.email)
      expect(mail.body.encoded).to include(answer.body)
    end
  end
end
