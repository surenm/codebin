class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :player_a, references: :users
      t.references :player_b, references: :users

      t.references :snippet_engine, references: :snippets
      t.references :snippet_a, references: :snippets
      t.references :snippet_b, references: :snippets

      t.references :game_type
      t.string :status
      t.text :log

      t.timestamps
    end

    create_table :game_types do |t|
      t.string :name
      t.string :engine_image
      t.string :allowed_player_images
      t.text :rules
    end
  end
end