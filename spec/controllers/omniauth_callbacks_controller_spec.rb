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

      it 'assigns the user' do
        post :facebook
        expect(assigns(:user)).to eq user
      end

      it 'signs in with user' do
        post :facebook
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        post :facebook
        expect(response).to redirect_to root_path
      end

      it 'not creates a user' do
        expect { post :facebook }.to_not change(User, :count)
      end

      it 'not creates authorization' do
        expect { post :facebook }.to_not change(Authorization, :count)
      end
    end

    context 'user has not authorization' do
      let!(:user) { create(:user, email: 'test@email.com') }

      it 'assigns the user' do
        post :facebook
        expect(assigns(:user)).to eq user
      end

      it 'signs in with user' do
        post :facebook
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        post :facebook
        expect(response).to redirect_to root_path
      end

      it 'not creates a user' do
        expect { post :facebook }.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect { post :facebook }.to change(user.authorizations, :count).by(1)
        expect(user.authorizations.first.provider).to eq 'facebook'
        expect(user.authorizations.first.uid).to eq '12345'
      end
    end

    context 'user does not exist' do
      it 'assigns the user' do
        post :facebook
        user = User.last
        expect(assigns(:user)).to eq user
      end

      it 'signs in with user' do
        post :facebook
        user = User.last
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        post :facebook
        expect(response).to redirect_to root_path
      end

      it 'creates a user' do
        expect { post :facebook }.to change(User, :count).by(1)
      end

      it 'creates authorization for user' do
        post :facebook
        user = User.last
        expect(user.authorizations.count).to eq 1
        expect(user.authorizations.first.provider).to eq 'facebook'
        expect(user.authorizations.first.uid).to eq '12345'
      end
    end
  end

  describe 'POST #twitter' do
    before do
      request.env['omniauth.auth'] = mock_twitter_hash
    end

    context 'user has authorization' do
      let!(:user) { create(:user, email: 'test@email.com') }
      let!(:authorization) { create(:authorization, provider: 'twitter', uid: '12345', user: user) }

      it 'assigns the user' do
        post :twitter
        expect(assigns(:user)).to eq user
      end

      it 'signs in with user' do
        post :twitter
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        post :twitter
        expect(response).to redirect_to root_path
      end

      it 'not creates a user' do
        expect { post :twitter }.to_not change(User, :count)
      end

      it 'not creates authorization' do
        expect { post :twitter }.to_not change(Authorization, :count)
      end
    end

    context 'user has not authorization' do
      it 'assigns the user' do
        post :twitter
        user = User.last
        expect(assigns(:user)).to eq user
      end

      it 'renders email_form template' do
        post :twitter
        expect(response).to render_template 'users/email_form'
      end

      it 'creates a user' do
        expect { post :twitter }.to change(User, :count)
      end

      it 'creates authorization for user' do
        post :twitter
        user = User.last
        expect(user.authorizations.count).to eq 1
        expect(user.authorizations.first.provider).to eq 'twitter'
        expect(user.authorizations.first.uid).to eq '12345'
      end
    end
  end
end
