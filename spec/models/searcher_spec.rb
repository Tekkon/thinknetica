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

        it 'finds object' do
          if object == 'all'
            klass.classify.constantize.stub(:search).and_return([user, question, answer, comment])
          else
            klass.classify.constantize.stub(:search).and_return([eval(object)])
          end

          result = Searcher.search(object, 'new')

          if object == 'user' || object == 'all'
            expect(result).to include({ id: user.id, type: 'User', title: user.email, body: user.email })
          elsif object == 'question' || object == 'all'
            expect(result).to include({ id: question.id, type: 'Question', title: question.title, body: question.body })
          elsif object == 'answer' || object == 'all'
            expect(result).to include({ id: question.id, type: 'Answer', title: answer.body, body: answer.body })
          elsif object == 'comment' || object == 'all'
            expect(result).to include({ id: question.id, type: 'Comment', title: comment.body, body: comment.body })
          end
        end
      end
    end
  end
end
