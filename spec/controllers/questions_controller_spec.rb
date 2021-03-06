require 'rails_helper'
require_relative 'concerns/voted_spec.rb'
require_relative 'concerns/commented_spec.rb'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

  let(:user) { create(:user) }
  let(:model) { Question }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question, user: user) }
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    let!(:question) { create(:question, user: user) }

    context "question's author" do
      before do
        sign_in_the_user(user)
        get :edit, params: { id: question }
      end

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context "not question's author" do
      sign_in_user

      before { get :edit, params: { id: question } }

      it 'redirects to root_path' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:request) { post :create, params: { question: attributes_for(:question) } }

      it_behaves_like 'savable'

      it 'redirects to show view' do
        request
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:request) { post :create, params: { question: attributes_for(:invalid_question) } }
      let(:template) { :new }

      it_behaves_like 'non-savable'
    end
  end

  describe 'PATCH #update' do
    let(:another_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: another_user) }

    before { sign_in_the_user(user) }

    it 'assigns requested question to @question' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
      question.reload
      expect(question.title).to eq 'new title'
      expect(question.body).to eq 'new body'
    end

    it 'not changes question if attributes is invalid' do
      patch :update, id: question, question: { title: nil, body: nil }, format: :js
      question.reload
      expect(question.title).to include 'What happened write after the big bang?'
      expect(question.body).to include 'I really want to know!'
    end

    it 'not changes question if user is not the author of the question' do
      patch :update, id: another_question, question: { title: 'new title', body: 'new body' }, format: :js
      another_question.reload
      expect(another_question.title).to include 'What happened write after the big bang?'
      expect(another_question.body).to include 'I really want to know!'
    end

    it 'renders update template' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }
    sign_in_user

    context 'user is the author of the question' do
      let(:request) { delete :destroy, params: { id: question }, format: :js }

      before { sign_in_the_user(user) }

      it_behaves_like 'destroyable'
    end

    context 'user is not the author of the question' do
      let(:request) { delete :destroy, params: { id: question }, format: :js }

      it_behaves_like 'non-destroyable'
    end
  end
end
