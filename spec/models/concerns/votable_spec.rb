require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for :votes }

  context 'methods' do
    let(:model) { described_class }
    let(:user) { create(:user) }
    let(:vote_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:votable) { model.to_s == 'Question' ? create(model.to_s.underscore.to_sym, user: user) : create(model.to_s.underscore.to_sym, user: user, question: question) }
    let!(:vote) { create(:vote, votable: votable, votable_type: model.to_s, vote_type: 1, user: vote_user) }

    it '#vote' do
      expect(votable.vote_by(vote_user)).to eq vote
    end

    it '#vote!' do
      expect { votable.vote!(user, 1) }.to change { Vote.count }.by(1)
    end

    it '#vote! with vote_type == 1' do
      vote = votable.vote!(user, 1)
      expect(vote.vote_type).to eq 1
    end

    it '#revote!' do
      expect { votable.revote!(vote_user) }.to change { Vote.count }.by(-1)
    end

    it '#rating' do
      expect(votable.rating).to eq 1
    end
  end
end
