class AddIndexToVote < ActiveRecord::Migration[5.0]
  def change
    add_index :votes, [:votable_id, :votable_type]
  end
end
