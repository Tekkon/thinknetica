require 'rails_helper'

describe 'Answer API' do
  let!(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachmentable: answer, file: Rails.root.join("spec/spec_helper.rb").open) }
      let(:answer_path) { '0/' }
      let(:comment_path) { '0/comments' }
      let(:attachment_path) { '0/attachments' }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it_behaves_like 'successable'
      it_behaves_like 'data-returnable'
      it_behaves_like 'answerable'
      it_behaves_like 'comment-includable'
      it_behaves_like 'attachment-includable'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: answer) }
    let!(:attachment) { create(:attachment, attachmentable: answer, file: Rails.root.join("spec/spec_helper.rb").open) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:answer_path) { '' }
      let(:attachment_path) { 'attachments' }
      let(:comment_path) { 'comments' }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'successable'
      it_behaves_like 'answerable'
      it_behaves_like 'comment-includable'
      it_behaves_like 'attachment-includable'
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:request) { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), access_token: access_token.token, format: :json } }
        let(:answer) { Answer.last }
        let(:answer_path) { '' }

        it_behaves_like 'creatable'

        context 'fields' do
          before { request }

          it_behaves_like 'answerable'
        end
      end

      context 'with invalid message' do
        let(:request) { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), access_token: access_token.token, format: :json }

        it_behaves_like 'non-creatable'
      end

      def model
        Answer
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end
