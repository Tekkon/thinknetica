class AddQuestionIdToAttachment < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :attachments, :question
  end
end
