class AttachmentsController < ApplicationController
  respond_to :js

  before_action :find_attachment, only: :destroy

  authorize_resource

  def destroy
    respond_with @attachment.destroy
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
