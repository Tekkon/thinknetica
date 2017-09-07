require 'rails_helper'
require_relative 'concerns/votable_spec.rb'
require_relative 'concerns/attachmentable_spec.rb'
require_relative 'concerns/commentable_spec.rb'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'attachmentable'
  it_behaves_like 'commentable'

  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
