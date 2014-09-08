class AddNameToSnippets < ActiveRecord::Migration
  def change
    add_column :snippets, :name, :string
  end
end
