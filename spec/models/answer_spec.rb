require 'rails_helper'

RSpec.describe Answer, type: :model do  
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of :body }

  context 'mark_favorite method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    it 'sets favorite field to true' do
      answer.mark_favorite
      answer.reload

      expect(answer.favorite).to eq true
    end
  end
end
