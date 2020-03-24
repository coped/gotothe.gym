class CreateExerciseMuscleGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :exercise_muscle_groups do |t|
      t.bigint :exercise_id
      t.bigint :muscle_group_id

      t.timestamps
    end
    add_foreign_key :exercise_muscle_groups, :exercises
    add_foreign_key :exercise_muscle_groups, :muscle_groups
    add_index :exercise_muscle_groups, :exercise_id
  end
end
