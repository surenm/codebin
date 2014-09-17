class AddEngineCodeToGameType < ActiveRecord::Migration
  def change
    add_column :game_types, :engine_code_github, :string
  end
end
