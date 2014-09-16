class AddInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :nick, :string
    add_column :users, :dp, :string
  end
end
