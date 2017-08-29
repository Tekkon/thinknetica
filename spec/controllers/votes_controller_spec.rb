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
      end

      context 'with invalid attributes' do
        it 'not saves the new vote in the database' do
          expect { post :create, params: { vote_type: '1' }, format: :json }.to_not change(Vote, :count)
        end
      end
    end

    context "Votable's author" do
      before { sign_in_the_user(user) }

      it 'not saves the new vote in the database' do
        expect { post :create, params: { votable_id: question, votable_type: 'Question', vote_type: '1' }, format: :json }.to_not change(Vote, :count)
      end
    end
  end

end
