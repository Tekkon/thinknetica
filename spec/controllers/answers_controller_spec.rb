require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'sets a current_user to the new answer' do
        sign_in_the_user(user)
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).user_id).to eq user.id
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before do
      question
      answer
    end

    context 'user is the author of the answer' do
      before { sign_in_the_user(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer.id }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'user is not the author of the answer' do
      it 'not deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer.id }, format: :js }.to_not change(Answer, :count)
      end
    end

    it 'renders destroy template' do
      delete :destroy, params: { question_id: question, id: answer.id }, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    let(:another_user) { create(:user) }
    let(:another_answer) { create(:answer, user: another_user, question: question) }

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

    it 'not changes answer if user is not the author of the answer' do
      patch :update, id: another_answer, question_id: question, answer: { body: 'new body' }, format: :js
      answer.reload
      expect(answer.body).to include 'I really want to know!'
    end

    it 'renders update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end

    it 'assigns requested answer as a favorite' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body', favorite: true }, format: :js
      answer.reload
      expect(answer.favorite).to eq true
    end

    it 'assigns only one answer as a favorite' do
      another_answer = create(:answer, question: question, user: user, favorite: true)

      patch :update, id: answer, question_id: question, answer: { body: 'new body', favorite: true }, format: :js
      answer.reload
      another_answer.reload

      expect(answer.favorite).to eq true
      expect(another_answer.favorite).to eq false
    end
  end
end
