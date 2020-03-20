class CreateWorkouts < ActiveRecord::Migration[6.0]
  def change
    create_table :workouts do |t|
      t.text :note
      t.datetime :date
      t.integer :user_id

      t.timestamps
    end

    add_index :workouts, [:user_id, :date]
    add_foreign_key :workouts, :users, column: :user_id 
  end
end
