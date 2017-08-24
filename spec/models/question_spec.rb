require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  context 'unmark_favorites method' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, user: user, question: question, favorite: false) }
    let!(:answer2) { create(:answer, user: user, question: question, favorite: true) }

    it 'sets question answers field favorite to false except the answer in parameter' do
      answer1.update(favorite: true)
      question.unmark_favorites(answer1)

      answer1.reload
      answer2.reload

      expect(answer1.favorite).to eq true
      expect(answer2.favorite).to eq false
    end
  end
end
