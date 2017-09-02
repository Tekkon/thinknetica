require 'rails_helper'
require_relative 'concerns/votable_spec.rb'
require_relative 'concerns/attachmentable_spec.rb'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'attachmentable'

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  context '#mark_favorite' do
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
