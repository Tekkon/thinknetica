class AddQuestionIdToAnswer < ActiveRecord::Migration[5.0]
  def change
  	add_belongs_to :answers, :question
  end
end
