require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:authorization) { create(:authorization, user: user) }

  describe 'PATCH #finish_signup' do
    context 'there is no user with the same email' do
      before do
        patch :finish_signup, params: { id: user, email: 'new@email.com' }
      end

      it 'assigns the user' do
        expect(assigns(:user)).to eq user
      end

      it 'updates user email' do
        user.reload
        expect(user.email).to eq 'new@email.com'
      end

      it 'signs in the user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to home' do
        expect(response).to redirect_to root_path
      end
    end

    context 'there is the user with the same email' do
      let!(:another_user) { create(:user, email: 'new@email.com') }

      it 'assigns the user' do
        patch :finish_signup, params: { id: user, email: 'new@email.com' }
        expect(assigns(:user)).to eq user
      end

      it 'assigns the another user' do
        patch :finish_signup, params: { id: user, email: 'new@email.com' }
        expect(assigns(:another_user)).to eq another_user
      end

      it 'deletes the user' do
        expect { patch :finish_signup, params: { id: user, email: 'new@email.com' } }.to change(User, :count).by(-1)
      end

      it "changes authorization's user" do
        expect { patch :finish_signup, params: { id: user, email: 'new@email.com' } }.to change(user.authorizations, :count).by(-1)

        another_user.reload
        auth = another_user.authorizations.first
        expect(auth.provider).to eq 'facebook'
        expect(auth.uid).to eq '12345'
      end

      it 'signs in the another user' do
        expect { patch :finish_signup, params: { id: user, email: 'new@email.com' } }.to change(User, :count).by(-1)
        expect(subject.current_user).to eq another_user
      end
    end
  end

  describe 'POST #send_finish_signup_email' do
    before do
      post :send_finish_signup_email, params: { id: user, user: { email: 'new@email.com' } }
    end

    it 'sends email' do
      expect(ActionMailer::Base.deliveries.first.subject).to eq 'Email confirmation'
    end

    it 'renders email_confirmation template' do
      expect(response).to render_template 'users/email_confirmation'
    end
  end
end
