class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])

    if current_user.author_of?(@attachment.attachmentable)
      @attachment.destroy
    else
      flash[:notice] = 'Only author of question or answer can remove attachment.'
    end
  end
end
