class MuscleGroup < ApplicationRecord
    # === Associations ===
    has_many :exercise_muscle_groups, foreign_key: :muscle_group_id
    has_many :exercises, through: :exercise_muscle_groups

    # === Validations ===
    validates :name, presence: true,
                     length: { maximum: 255 }
end
