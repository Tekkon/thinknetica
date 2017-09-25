require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do

    %w(question comment answer user all).each do |object|
      context "Search #{object}" do
        let(:request) { get :index, object: object, text: 'new' }

        it 'calls search' do
          expect(Searcher).to receive(:search).with(object, 'new')
          request
        end

        it 'renders index view' do
          request
          expect(response).to render_template :index
        end
      end
    end
  end
end
