require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context 'author_of? method' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: another_user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:another_answer) { create(:answer, user: another_user, question: another_question) }

    it 'returns true if user is the author of the question' do
      user.author_of?(question).should eq true
    end

    it 'returns false if user is not the author of the question' do
      user.author_of?(another_question).should eq false
    end

    it 'returns true if user is the quthor of the answer' do
      user.author_of?(answer).should eq true
    end

    it 'returns false if user is not the author of the answer' do
      user.author_of?(another_answer).should eq false
    end

    it 'returns exception if object is not a question nor answer' do
      expect { user.author_of?(another_user) }.to raise_error
    end
  end
end
