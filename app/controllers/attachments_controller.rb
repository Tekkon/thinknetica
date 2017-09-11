class AttachmentsController < ApplicationController
  respond_to :js

  before_action :find_attachment, only: :destroy

  authorize_resource

  def destroy
    flash[:notice] = 'Only author of question or answer can remove attachment.' unless is_attachmentable_author?
    respond_with @attachment.destroy if is_attachmentable_author?
  end

  private

  def is_attachmentable_author?
    current_user.author_of?(@attachment.attachmentable)
  end

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
