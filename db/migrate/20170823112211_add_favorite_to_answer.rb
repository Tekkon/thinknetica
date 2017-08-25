class AddFavoriteToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :favorite, :bool, default: false
  end
end
