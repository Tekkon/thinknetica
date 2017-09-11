require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :read, Question }
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question, user: user  }
      it { should_not be_able_to :update, create(:question, user: another_user), user: user  }

      it { should be_able_to :edit, question, user: user }
      it { should_not be_able_to :edit, create(:question, user: another_user), user: user  }

      it { should be_able_to :destroy, question, user: user  }
      it { should_not be_able_to :destroy, create(:question, user: another_user), user: user  }
    end

    context 'Answer' do
      it { should be_able_to :read, Answer }
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, create(:answer, question: question, user: user), user: user  }
      it { should_not be_able_to :update, create(:answer, question: question, user: another_user), user: user  }

      it { should be_able_to :edit, create(:answer, question: question, user: user), user: user  }
      it { should_not be_able_to :edit, create(:answer, question: question, user: another_user), user: user  }

      it { should be_able_to :destroy, create(:answer, question: question, user: user), user: user  }
      it { should_not be_able_to :destroy, create(:answer, question: question, user: another_user), user: user  }

      it { should be_able_to :mark_favorite, create(:answer, question: question, user: user), user: user  }
      it { should_not be_able_to :mark_favorite, create(:answer, question: create(:question, user: another_user), user: user), user: user  }
    end

    context 'Comment' do
      it { should be_able_to :read, Comment }
      it { should be_able_to :create, Comment }

      it { should be_able_to :update, create(:comment, body: 'new comment', commentable: question, user: user), user: user  }
      it { should_not be_able_to :update, create(:comment, body: 'new comment', commentable: question, user: another_user), user: user  }

      it { should be_able_to :edit, create(:comment, body: 'new comment', commentable: question, user: user), user: user  }
      it { should_not be_able_to :edit, create(:comment, body: 'new comment', commentable: question, user: another_user), user: user  }

      it { should be_able_to :destroy, create(:comment, body: 'new comment', commentable: question, user: user), user: user  }
      it { should_not be_able_to :destroy, create(:comment, body: 'new comment', commentable: question, user: another_user), user: user  }
    end

    context 'Attachment' do
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, question: question, user: user) }
      let(:other_question) { create(:question, user: another_user) }
      let(:other_answer) { create(:answer, question: question, user: another_user) }
      let(:file) { Rails.root.join("spec/spec_helper.rb").open }

      it { should be_able_to :read, Attachment }
      it { should be_able_to :create, Attachment }

      it { should be_able_to :destroy, create(:attachment, attachmentable: question, file: file), user: user }
      it { should be_able_to :destroy, create(:attachment, attachmentable: answer, file: file), user: user }

      it { should_not be_able_to :destroy, create(:attachment, attachmentable: other_question, file: file), user: user }
      it { should_not be_able_to :destroy, create(:attachment, attachmentable: other_answer, file: file), user: user }
    end

    context 'Commentable' do
      it { should be_able_to :comment, create(:answer, question: question, user: user) }
      it { should be_able_to :comment, create(:question, user: user) }
    end

    context 'Votable' do
      let!(:voted_answer) { create(:answer, question: question, user: another_user) }
      let!(:vote1) { create(:vote, user: user, votable: voted_answer, vote_type: 1) }
      let!(:voted_question) { create(:question, user: another_user) }
      let!(:vote2) { create(:vote, user: user, votable: voted_question, vote_type: 1) }

      it { should be_able_to :vote_for, create(:question, user: another_user), user: user }
      it { should_not be_able_to :vote_for, create(:question, user: user), user: user }
      it { should be_able_to :vote_for, create(:answer, question: question, user: another_user), user: user }
      it { should_not be_able_to :vote_for, create(:answer, question: question, user: user), user: user }
      it { should_not be_able_to :vote_for, voted_answer, user: user }
      it { should_not be_able_to :vote_for, voted_question, user: user }

      it { should be_able_to :vote_against, create(:question, user: another_user), user: user }
      it { should_not be_able_to :vote_against, create(:question, user: user), user: user }
      it { should be_able_to :vote_against, create(:answer, question: question, user: another_user), user: user }
      it { should_not be_able_to :vote_against, create(:answer, question: question, user: user), user: user }
      it { should_not be_able_to :vote_against, voted_answer, user: user }
      it { should_not be_able_to :vote_against, voted_question, user: user }

      it { should be_able_to :revote, voted_answer, user: user }
      it { should be_able_to :revote, voted_question, user: user}
      it { should_not be_able_to :revote, create(:question, user: another_user), user: user }
      it { should_not be_able_to :revote, create(:answer, question: question, user: another_user), user: user }
    end
  end
end
