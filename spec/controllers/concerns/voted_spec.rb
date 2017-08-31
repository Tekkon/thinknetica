require 'rails_helper'

shared_examples "voted" do
  let(:model) { described_class.controller_name.classify }

  describe 'POST #vote' do
    let!(:votable) { model == 'Question' ? create(model.underscore.to_sym, user: user) : create(model.underscore.to_sym, user: user, question: question) }

    context "Not votable's author" do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new vote in the database' do
          expect { post :vote, params: { id: votable, vote_type: '1' }, format: :json }.to change(Vote, :count).by(1)
        end

        it 'renders create_voted vote' do
          post :vote, params: { id: votable, vote_type: '1' }, format: :json
          expect(JSON.parse(response.body)['vote']['id']).to eq Vote.first.id
        end
      end
    end

    context "Votable's author" do
      before { sign_in_the_user(user) }

      it 'not saves the new vote in the database' do
        expect { post :vote, params: { id: votable, vote_type: '1' }, format: :json }.to_not change(Vote, :count)
      end

      it 'renders error' do
        post :vote, params: { id: votable, vote_type: '1' }, format: :json
        expect(JSON.parse(response.body)['error']).to eq "Author can't vote his question or answer."
      end
    end
  end

  describe 'POST #revote' do
    let(:another_user) { create(:user) }
    let!(:votable) { model == 'Question' ? create(model.underscore.to_sym, user: user) : create(model.underscore.to_sym, user: user, question: question) }
    let!(:vote) { create(:vote, user: another_user, votable: votable, vote_type: 1) }

    context 'user is the author of the vote' do
      before { sign_in_the_user(another_user) }

      it 'deletes the vote' do
        expect { post :revote, params: { id: votable }, format: :json }.to change(Vote, :count).by(-1)
      end

      it 'renders deleted vote' do
        id = vote.id
        post :revote, params: { id: votable }, format: :json
        expect(JSON.parse(response.body)['vote']['id']).to eq id
      end
    end

    context 'user is not the author of the vote' do
      sign_in_user

      it 'not deletes the vote' do
        expect { post :revote, params: { id: votable }, format: :json }.to_not change(Vote, :count)
      end

      it 'renders error' do
        post :revote, params: { id: votable }, format: :json
        expect(JSON.parse(response.body)['error']).to eq "Only the author of the vote can delete it."
      end
    end
  end
end
