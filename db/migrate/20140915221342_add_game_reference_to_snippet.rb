class AddGameReferenceToSnippet < ActiveRecord::Migration
  def change
    add_reference :snippets, :game, index: true
  end
end
