require 'rails_helper'

describe 'Question API' do
  let(:access_token) { create(:access_token) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachmentable: question, file: Rails.root.join("spec/spec_helper.rb").open) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it_behaves_like 'successable'
      it_behaves_like 'data-returnable'
      it_behaves_like 'questionable'
      it_behaves_like 'answer-includable'
      it_behaves_like 'comment-includable'
      it_behaves_like 'attachment-includable'
      it_behaves_like 'short-titlable'

      def answer_path
        '0/answers'
      end

      def attachment_path
        '0/attachments'
      end

      def comment_path
        '0/comments'
      end

      def question_path
        '0/'
      end

      def short_title_path
        '0/short_title'
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: question) }
    let!(:attachment) { create(:attachment, attachmentable: question, file: Rails.root.join("spec/spec_helper.rb").open) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'successable'
      it_behaves_like 'questionable'
      it_behaves_like 'answer-includable'
      it_behaves_like 'comment-includable'
      it_behaves_like 'attachment-includable'
      it_behaves_like 'short-titlable'

      def answer_path
        'answers'
      end

      def attachment_path
        'attachments'
      end

      def comment_path
        'comments'
      end

      def question_path
        ''
      end

      def short_title_path
        'short_title'
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:request) { post "/api/v1/questions", question: attributes_for(:question), access_token: access_token.token, format: :json }

        it_behaves_like 'creatable'

        context 'fields' do
          before { request }

          it_behaves_like 'questionable'

          def question
            Question.last
          end

          def question_path
            ''
          end
        end
      end

      context 'with invalid attributes' do
        let(:request) { post "/api/v1/questions", question: attributes_for(:invalid_question), access_token: access_token.token, format: :json }

        it_behaves_like 'non-creatable'
      end

      def model
        Question
      end
    end

    def do_request(options = {})
      post "/api/v1/questions", { format: :json }.merge(options)
    end
  end
end
