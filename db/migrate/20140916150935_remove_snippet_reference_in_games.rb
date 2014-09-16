class RemoveSnippetReferenceInGames < ActiveRecord::Migration
  def change
    remove_reference :games, :snippet_a
    remove_reference :games, :snippet_b
    remove_reference :games, :snippet_engine
  end
end
