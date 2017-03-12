class CreateDynes < ActiveRecord::Migration[5.0]
  def change
    create_table :dynes do |t|
      t.string :name
      t.integer :unit_id

      t.timestamps
    end
  end
end
