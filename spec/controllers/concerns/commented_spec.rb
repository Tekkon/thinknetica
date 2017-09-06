require 'rails_helper'

shared_examples 'commented' do
  let(:model) { described_class.controller_name.classify }

  describe "POST #comment" do
    sign_in_user
    let!(:commentable) { model == 'Question' ? create(model.underscore.to_sym, user: user) : create(model.underscore.to_sym, user: user, question: question) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :comment, params: { id: commentable, comment: { body: 'new comment' } }, format: :json }.to change(Comment, :count).by(1)
      end

      it 'renders created comment' do
        post :comment, params: { id: commentable, comment: { body: 'new comment' } }, format: :json
        expect(JSON.parse(response.body)['comment']['id']).to eq Comment.first.id
      end
    end

    context 'with invalid attributes' do
      it 'not saves a new comment in the databse' do
        expect { post :comment, params: { id: commentable, comment: { body: nil } }, format: :json }.to_not change(Comment, :count)
      end

      it 'renders error' do
        post :comment, params: { id: commentable, comment: { body: nil } }, format: :json
        expect(JSON.parse(response.body)['errors'][0]).to eq "Body can't be blank"
      end
    end
  end
end
