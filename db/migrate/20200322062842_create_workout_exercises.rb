class CreateWorkoutExercises < ActiveRecord::Migration[6.0]
  def change
    create_table :workout_exercises do |t|
      t.references :workout, foreign_key: true
      t.references :exercise, foreign_key: true
      t.integer :order

      t.timestamps
    end

  end
end
