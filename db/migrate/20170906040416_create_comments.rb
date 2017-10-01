class CreateComment < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :commentable_id
      t.string :commentable_type
      t.string :body

      t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
