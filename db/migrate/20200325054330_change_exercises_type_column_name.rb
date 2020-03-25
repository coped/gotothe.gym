class ChangeExercisesTypeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :exercises, :type, :movement_type
  end
end
