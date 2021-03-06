require 'rails_helper'
require_relative 'concerns/voted_spec.rb'
require_relative 'concerns/commented_spec.rb'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:model) { Answer }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:request) { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }

      it_behaves_like 'savable'

      it 'renders create template' do
        request
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:request) { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }
      let(:template) { :create }

      it_behaves_like 'non-savable'
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    # before do
    #   question
    #   answer
    # end

    context 'user is the author of the answer' do
      let(:request) { delete :destroy, params: { question_id: question, id: answer.id }, format: :js }

      before { sign_in_the_user(user) }

      it_behaves_like 'destroyable'
    end

    context 'user is not the author of the answer' do
      let(:request) { delete :destroy, params: { question_id: question, id: answer.id }, format: :js }

      it_behaves_like 'non-destroyable'
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:another_user) { create(:user) }
    let(:another_answer) { create(:answer, user: another_user, question: question) }

    context "Answer's author" do
      before { sign_in_the_user user }

      it 'assigns requested answer to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assignes the question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'not changes answer if attributes is invalid' do
        patch :update, id: answer, question_id: question, answer: { body: nil }, format: :js
        answer.reload
        expect(answer.body).to include 'I really want to know!'
      end

      it 'renders update template' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context "Not answer's author" do
      it 'not changes answer' do
        patch :update, id: another_answer, question_id: question, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to include 'I really want to know!'
      end

      it 'renders forbidden' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response.status).to eq 403
      end
    end
  end

  describe 'PUT #mark_favorite' do
    sign_in_user
    let!(:another_answer) { create(:answer, question: question, user: user, favorite: true) }

    context "Question's author" do
      before { sign_in_the_user user }

      it 'assigns requested answer as a favorite' do
        put :mark_favorite, id: answer, question_id: question, format: :js
        answer.reload
        expect(answer.favorite).to eq true
      end

      it 'assigns only one answer as a favorite' do
        put :mark_favorite, id: answer, question_id: question, format: :js
        answer.reload
        another_answer.reload

        expect(answer.favorite).to eq true
        expect(another_answer.favorite).to eq false
      end
    end

    context "Not question's author" do
      it 'not assigns requested answer as a favorite' do
        put :mark_favorite, id: answer, question_id: question, format: :js
        answer.reload
        expect(answer.favorite).to eq false
      end

      it 'renders forbidden' do
        put :mark_favorite, id: answer, question_id: question, format: :js
        expect(response.status).to eq 403
      end
    end
  end
end
