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

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it_behaves_like 'successable'
      it_behaves_like 'data-returnable'
      it_behaves_like 'answerable'
      it_behaves_like 'comment-includable'
      it_behaves_like 'attachment-includable'

      def answer_path
        '0/'
      end

      def comment_path
        '0/comments'
      end

      def attachment_path
        '0/attachments'
      end
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
      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'successable'
      it_behaves_like 'answerable'
      it_behaves_like 'comment-includable'
      it_behaves_like 'attachment-includable'

      # %w(id body created_at updated_at).each do |attr|
      #   it "question object contains #{attr}" do
      #     expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
      #   end
      # end

      # context 'comments' do
      #   it 'included in answer object' do
      #     expect(response.body).to have_json_size(1).at_path('comments')
      #   end
      #
      #   %w(id user_id body created_at updated_at).each do |attr|
      #     it "contains #{attr}" do
      #       expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
      #     end
      #   end
      # end
      #
      # context 'attachments' do
      #   it 'included in question object' do
      #     expect(response.body).to have_json_size(1).at_path('attachments')
      #   end
      #
      #   it "contains file_url" do
      #     expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/file_url")
      #   end
      # end

      def answer_path
        ''
      end

      def attachment_path
        'attachments'
      end

      def comment_path
        'comments'
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:request) { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), access_token: access_token.token, format: :json }

        it_behaves_like 'creatable'

        context 'fields' do
          before { request }

          it_behaves_like 'answerable'

          def answer
            Answer.last
          end

          def answer_path
            ''
          end
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
