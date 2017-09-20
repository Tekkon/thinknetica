require 'rails_helper'
require_relative 'concerns/votable_spec.rb'
require_relative 'concerns/attachmentable_spec.rb'
require_relative 'concerns/commentable_spec.rb'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'attachmentable'
  it_behaves_like 'commentable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  context "#create_subscription" do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'triggers create_subscription on create' do
      expect(question).to receive(:create_subscription)
      question.save
    end

    it 'does not trigger create_subscription on update' do
      expect(question).to receive(:create_subscription)
      question.update(body: 'new question')
    end

    it 'creates subscription' do
      expect { question.save }.to change(Subscription, :count).by(1)
    end
  end
end
