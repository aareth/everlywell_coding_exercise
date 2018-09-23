class CreateHeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :headers do |t|
      t.integer :expert_id
      t.string :text
    end
  end
end
