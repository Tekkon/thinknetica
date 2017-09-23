require 'rails_helper'
require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    before { index }

    %w(question comment answer user all).each do |object|
      context "Search #{object}" do
        let(:request) { get :index, object: object, text: 'new' }
        let(:klass) { object == 'all' ? 'ThinkingSphinx' : object }

        ThinkingSphinx::Test.run do
          it 'calls search' do
            expect(klass.classify.constantize).to receive(:search).with('new', page: 1)
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
end
