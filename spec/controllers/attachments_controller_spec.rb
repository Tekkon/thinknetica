require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachmentable: question, file: Rails.root.join("spec/spec_helper.rb").open) }

  describe 'DELETE #destroy' do
    context 'user is the author of the attachmentable' do
      before { sign_in_the_user(user) }

      it 'deletes the attachment' do
        expect { delete :destroy, params: { id: attachment }, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'renders template destroy' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not the author of the attachmentable' do
      sign_in_user

      it 'not deletes the attachment' do
        expect { delete :destroy, params: { id: attachment }, format: :js }.to_not change(Attachment, :count)
      end

      it 'renders template destroy' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end