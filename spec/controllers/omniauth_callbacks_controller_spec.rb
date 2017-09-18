require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'POST #facebook' do
    before do
      request.env['omniauth.auth'] = mock_facebook_hash
    end

    context 'user has authorization' do
      let!(:user) { create(:user, email: 'test@email.com') }
      let!(:authorization) { create(:authorization, user: user) }

      it_behaves_like 'assignable'
      it_behaves_like 'signinable'
      it_behaves_like 'not-user-creatable'
      it_behaves_like 'not-authorizable'
    end

    context 'user has not authorization' do
      let!(:user) { create(:user, email: 'test@email.com') }

      it 'assigns the user' do
        post :facebook
        expect(assigns(:user)).to eq user
      end

      it_behaves_like 'assignable'
      it_behaves_like 'signinable'
      it_behaves_like 'not-user-creatable'
      it_behaves_like 'authorizable'
    end

    context 'user does not exist' do
      it_behaves_like 'assignable'
      it_behaves_like 'signinable'
      it_behaves_like 'user-creatable'
      it_behaves_like 'authorizable'

      def user
        User.last
      end
    end

    def method
      'facebook'
    end
  end

  describe 'POST #twitter' do
    before do
      request.env['omniauth.auth'] = mock_twitter_hash
    end

    context 'user has authorization' do
      let!(:user) { create(:user, email: 'test@email.com') }
      let!(:authorization) { create(:authorization, provider: 'twitter', uid: '12345', user: user) }

      it_behaves_like 'assignable'
      it_behaves_like 'signinable'
      it_behaves_like 'not-user-creatable'
      it_behaves_like 'not-authorizable'
    end

    context 'user has not authorization' do
      it_behaves_like 'assignable'
      it_behaves_like 'user-creatable'
      it_behaves_like 'authorizable'

      it 'renders email_form template' do
        post :twitter
        expect(response).to render_template 'users/email_form'
      end

      def user
        User.last
      end
    end

    def method
      'twitter'
    end
  end
end
