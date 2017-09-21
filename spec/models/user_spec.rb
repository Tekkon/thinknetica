require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context '#author_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: another_user) }

    it 'returns true if user is the author of the question' do
      expect(user).to be_author_of(question)
    end

    it 'returns false if user is not the author of the question' do
      expect(user).to_not be_author_of(another_question)
    end

    it 'returns false if parameter is nil' do
      expect(user).to_not be_author_of(nil)
    end
  end

  context '#subscriber_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: another_user) }

    it 'returns true if user is the subscriber of the question' do
      expect(user).to be_subscriber_of(question)
    end

    it 'returns fale is user is not the subscriber of the question' do
      expect(user).to_not be_subscriber_of(another_question)
    end

    it 'returns false if parameter is nil' do
      expect(user).to_not be_subscriber_of(nil)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '12345')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context 'email is empty' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: {}) }

        it 'returns a new User' do
          expect(User.find_for_oauth(auth)).to be_a_new(User)
        end
      end
    end
  end

  describe '.create_user_and_auth' do
    let(:email) { 'test@email.com' }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

    it 'creates new user' do
      expect { User.create_user_and_auth(email, auth.provider, auth.uid) }.to change(User, :count).by(1)
    end

    it 'returns new user' do
      expect(User.create_user_and_auth(email, auth.provider, auth.uid)).to be_a(User)
    end

    it 'creates authorization for user' do
      expect(User.create_user_and_auth(email, auth.provider, auth.uid).authorizations).to_not be_empty
    end

    it 'creates authorization with provider and uid' do
      authorization = User.create_user_and_auth(email, auth.provider, auth.uid).authorizations.first
      expect(authorization.provider).to eq auth.provider
      expect(authorization.uid).to eq auth.uid
    end
  end
end
