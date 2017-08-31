require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context "Not votable's author" do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new vote in the database' do
          expect { post :create, params: { votable_id: question, votable_type: 'Question', vote_type: '1' }, format: :json }.to change(Vote, :count).by(1)
        end

        it 'renders created vote' do
          post :create, params: { votable_id: question, votable_type: 'Question', vote_type: '1' }, format: :json
          expect(JSON.parse(response.body)['vote']['id']).to eq Vote.first.id
        end
      end

      context 'with invalid attributes' do
        it 'not saves the new vote in the database' do
          expect { post :create, params: { vote_type: '1' }, format: :json }.to_not change(Vote, :count)
        end

        it 'renders error' do
          post :create, params: { vote_type: '1' }, format: :json
          expect(response.body).to include 'error'
        end
      end
    end

    context "Votable's author" do
      before { sign_in_the_user(user) }

      it 'not saves the new vote in the database' do
        expect { post :create, params: { votable_id: question, votable_type: 'Question', vote_type: '1' }, format: :json }.to_not change(Vote, :count)
      end

      it 'renders error' do
        post :create, params: { votable_id: question, votable_type: 'Question', vote_type: '1' }, format: :json
        expect(JSON.parse(response.body)['error']).to eq "Author can't vote his question or answer."
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }
    let!(:vote) { create(:vote, user: another_user, votable: question, votable_type: 'Question', vote_type: 1) }

    context 'user is the author of the vote' do
      before { sign_in_the_user(another_user) }

      it 'deletes the vote' do
        expect { delete :destroy, params: { id: vote }, format: :json }.to change(Vote, :count).by(-1)
      end

      it 'renders deleted vote' do
        id = vote.id
        delete :destroy, params: { id: vote }, format: :json
        expect(JSON.parse(response.body)['vote']['id']).to eq id
      end
    end

    context 'user is not the author of the vote' do
      sign_in_user

      it 'not deletes the vote' do
        expect { delete :destroy, params: { id: vote }, format: :json }.to_not change(Vote, :count)
      end

      it 'renders error' do
        delete :destroy, params: { id: vote }, format: :json
        expect(JSON.parse(response.body)['error']).to eq "Only the author of the vote can delete it."
      end
    end
  end

end
