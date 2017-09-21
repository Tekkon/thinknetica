require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in_the_user(user) }

  describe 'POST #create' do
    let!(:question) { create(:question) }
    let(:request) { post :create, question_id: question, format: :json }

    context 'user is not subscribed' do
      it 'return status 200' do
        request
        expect(response).to be_success
      end

      it 'creates a subscription' do
        expect { request }.to change(Subscription, :count).by(1)
      end

      it 'renders subscription object' do
        request
        expect(response.body).to be_json_eql(question.id).at_path('question_id')
        expect(response.body).to be_json_eql(user.id).at_path('user_id')
      end
    end

    context 'user is subscribed alredy' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it_behaves_like 'not create subscription'
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }
    let!(:subscription1) { create(:subscription, user: user) }
    let!(:subscription2) { create(:subscription, user: another_user) }

    context 'user can delete his subscription' do
      let(:request) { delete :destroy, id: subscription1, format: :json  }

      it 'return status 200' do
        request
        expect(response).to be_success
      end

      it 'deletes the subscription' do
        expect { request }.to change(Subscription, :count).by(-1)
      end

      it 'renders empty string' do
        request
        expect(response.body).to eq '"nothing"'
      end
    end

    context "user can't delete another users's subscription" do
      let(:request) { delete :destroy, id: subscription2, format: :json  }

      it_behaves_like 'not create subscription'
    end
  end
end
