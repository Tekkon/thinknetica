require 'rails_helper'

RSpec.describe Searcher, type: :model do
  context '#search' do
    let!(:user) { create(:user, email: 'new@email.com') }
    let!(:question) { create(:question, title: 'new', body: 'new') }
    let!(:answer) { create(:answer, body: 'new', question: question) }
    let!(:comment) { create(:comment, body: 'new', commentable: question) }

    %w(question comment answer user all).each do |object|
      context "#{object}" do
        let(:klass) { object == 'all' ? 'ThinkingSphinx' : object }

        it 'calls search' do
          expect(klass.classify.constantize).to receive(:search).with('new', page: 1)
          Searcher.search(object, 'new')
        end
      end
    end

    it 'finds question' do
      Question.stub(:search).and_return([question])
      expect(Searcher.search('question', 'new')).to include({ id: question.id, type: 'Question', title: question.title, body: question.body })
    end

    it 'finds answer' do
      Answer.stub(:search).and_return([answer])
      expect(Searcher.search('answer', 'new')).to include({ id: question.id, type: 'Answer', title: answer.body, body: answer.body })
    end

    it 'finds comment' do
      Comment.stub(:search).and_return([comment])
      expect(Searcher.search('comment', 'new')).to include({ id: question.id, type: 'Comment', title: comment.body, body: comment.body })
    end

    it 'finds user' do
      User.stub(:search).and_return([user])
      expect(Searcher.search('user', 'new')).to include({ id: user.id, type: 'User', title: user.email, body: user.email })
    end

    it 'finds all objects' do
      ThinkingSphinx.stub(:search).and_return([user, question, answer, comment])
      expect(Searcher.search('all', 'new')).to include({ id: question.id, type: 'Question', title: question.title, body: question.body })
      expect(Searcher.search('all', 'new')).to include({ id: question.id, type: 'Answer', title: answer.body, body: answer.body })
      expect(Searcher.search('all', 'new')).to include({ id: question.id, type: 'Comment', title: comment.body, body: comment.body })
      expect(Searcher.search('all', 'new')).to include({ id: user.id, type: 'User', title: user.email, body: user.email })
    end
  end
end
