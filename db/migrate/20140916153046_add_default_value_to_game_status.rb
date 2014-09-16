class AddDefaultValueToGameStatus < ActiveRecord::Migration
  def change
    change_column_default :games, :status, :waiting
  end
end
