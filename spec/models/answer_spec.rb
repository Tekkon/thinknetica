require 'rails_helper'
require_relative 'concerns/votable_spec.rb'
require_relative 'concerns/attachmentable_spec.rb'
require_relative 'concerns/commentable_spec.rb'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'attachmentable'
  it_behaves_like 'commentable'

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

  context '#send_question_updates' do
    let(:question) { create(:question) }
    let(:object) { build(:answer, question: question) }
    let(:method) { 'send_question_updates' }
    let!(:users) { create_list(:user, 2) }
    let!(:subscription1) { create(:subscription, user: users.first, question: question) }
    let!(:subscription2) { create(:subscription, user: users.last, question: question) }

    it_behaves_like 'after create'

    it 'sends created answer to subscribers' do
      Subscription.where(question_id: question) do |s|
        expect(QuestionUpdateJob).to receive(:perform_later).with(s.user, object).and_call_original
      end

      object.save
    end
  end
end
