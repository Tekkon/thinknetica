require 'rails_helper'

RSpec.describe QuestionUpdateJob, type: :job do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }

  it 'should send email about new answer to the author of the question' do
    expect(DailyMailer).to receive(:question_update).with(user, answer).and_call_original
    QuestionUpdateJob.perform_now(answer)
  end
end
