require 'rails_helper'

RSpec.describe Answer, type: :model do  
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  context 'mark_favorite method' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let!(:favorite_answer) { create(:answer, user: user, question: question, favorite: true) }

    it 'sets favorite field to true' do
      answer.mark_favorite
      answer.reload

      expect(answer.favorite).to eq true
    end

    it 'sets favorite=false to other answers' do
      answer.mark_favorite
      answer.reload
      favorite_answer.reload

      expect(favorite_answer.favorite).to eq false
    end
  end
end
