class ChangeWorkoutsUserIdColumnTypeToBigInt < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :workouts, :user_id, :bigint
      end

      dir.down do 
        change_column :workouts, :user_id, :integer
      end
    end
  end
end
