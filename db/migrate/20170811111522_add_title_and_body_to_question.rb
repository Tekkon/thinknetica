class AddTitleAndBodyToQuestion < ActiveRecord::Migration[5.0]
  def change
  	add_column :questions, :title, :string
  	add_column :questions, :body, :text
  end
end
