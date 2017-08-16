require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'sets a current_user to the new answer' do
        sign_in_the_user(user)
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(question.answers.last.user_id).to eq user.id
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-renders question view' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template 'questions/show'
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
        expect { delete :destroy, params: { question_id: question, id: answer.id } }.to change(Answer, :count).by(-1)
      end
    end

    context 'user is not the author of the answer' do
      it 'not deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer.id } }.to_not change(Answer, :count)
      end
    end

    it 'redirects to question view' do
      delete :destroy, params: { question_id: question, id: answer.id }
      expect(response).to redirect_to question_path(question)
    end
  end
end
