class WorkoutExercise < ApplicationRecord
    # === Associations ===
    belongs_to :workout
    belongs_to :exercise

    # === Validations ===
    validates_presence_of :workout
    validates_presence_of :exercise
end
