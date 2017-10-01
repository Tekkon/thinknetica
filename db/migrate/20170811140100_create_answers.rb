class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.text :body

      t.timestamps
    end

    add_belongs_to :answers, :question
  end
end
