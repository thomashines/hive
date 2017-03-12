class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :learn_link
      t.string :github_root
      t.string :flat_file
      t.boolean :solution
      t.integer :dyne_id

      t.timestamps
    end
  end
end
