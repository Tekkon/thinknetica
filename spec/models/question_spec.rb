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
    let(:object) { build(:question, user: user) }
    let(:method) { 'create_subscription' }

    it_behaves_like 'after create'

    it 'creates subscription' do
      expect { object.save }.to change(Subscription, :count).by(1)
    end
  end

  context "#get_subscription" do
    let(:user) { create(:user) }

    context 'subscription exists' do
      let!(:question) { create(:question, user: user) }

      it 'returns subscription' do
        expect(question.get_subscription(user)).to eq question.subscriptions.first
      end
    end

    context 'subscription does not exist' do
      let(:question) { create(:question) }

      it 'returns nothing' do
        expect(question.get_subscription(user)).to eq nil
      end
    end
  end
end
