class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.text :image
      t.references :card_type
      t.integer :card_weight
      t.timestamps
    end
  end
end
