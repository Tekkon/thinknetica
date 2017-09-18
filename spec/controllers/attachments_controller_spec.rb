require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachmentable: question, file: Rails.root.join("spec/spec_helper.rb").open) }

  describe 'DELETE #destroy' do
    context 'user is the author of the attachmentable' do
      let(:request) { delete :destroy, params: { id: attachment }, format: :js }

      before { sign_in_the_user(user) }

      it_behaves_like 'destroyable'
    end

    context 'user is not the author of the attachmentable' do
      let(:request) { delete :destroy, params: { id: attachment }, format: :js }

      sign_in_user

      it_behaves_like 'non-destroyable'
    end
  end

  def model
    Attachment
  end
end
