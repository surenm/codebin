class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.belongs_to :snippet
      t.string :image
      t.string :container_id
      t.boolean :clean_exit
      t.timestamps
    end

    add_index :containers, :container_id
  end
end
