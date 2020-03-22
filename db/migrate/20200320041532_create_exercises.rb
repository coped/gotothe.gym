class CreateExercises < ActiveRecord::Migration[6.0]
  def change
    create_table :exercises do |t|
      t.string :image_id
      t.string :name
      t.string :title
      t.text :primer
      t.string :type
      t.string :equipment
      t.string :secondary_muscle_groups
      t.text :steps
      t.text :tips

      t.timestamps
    end
    add_index :exercises, :name
  end
end
