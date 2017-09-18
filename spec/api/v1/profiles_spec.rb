require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token  }

      it_behaves_like 'successable'
      it_behaves_like 'profilable'

      def profile_path
        ''
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token  }

      it_behaves_like 'successable'
      it_behaves_like 'data-returnable'
      it_behaves_like 'profilable'

      it 'does not render authenticated user' do
        parse_json(response.body).each do |item|
          expect(item['id']).to_not eq me.id
        end
      end

      def profile_path
        '0/'
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', { format: :json }.merge(options)
    end

    def profile_path
      ''
    end
  end
end
