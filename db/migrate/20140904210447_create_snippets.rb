class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.references :user
      t.text :code
      t.string :language
      t.string :status
      t.string :input
      t.string :output
      t.string :error
      t.timestamps
    end
  end
end
