class ExerciseMuscleGroup < ApplicationRecord
    # === Associations ===
    belongs_to :exercise
    belongs_to :muscle_group

    # === Validations ===
    validates_presence_of :exercise
    validates_presence_of :muscle_group
end
