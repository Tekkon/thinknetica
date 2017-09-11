# require 'rails_helper'
#
# RSpec.describe AnswerPolicy do
#
#   let(:user) { create(:user) }
#   let(:question) { create(:question, user: user) }
#
#   subject { described_class }
#
#   permissions :update? do
#     it 'grants access if user is admin' do
#       expect(subject).to permit(User.new(admin: true), create(:answer, question: question, user: user))
#     end
#
#     it 'grants access if user is the author of the answer' do
#       expect(subject).to permit(user, create(:answer, question: question, user: user))
#     end
#
#     it 'denies access if use is not the author of the answer' do
#       expect(subject).to_not permit(User.new, create(:answer, question: question, user: user))
#     end
#   end
# end
