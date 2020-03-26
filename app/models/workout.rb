class Workout < ApplicationRecord
    # === Associations ===
    belongs_to :user
    has_many :exercises, through: :workout_exercises

    # === Validations ===
    validates :note,    length: { maximum: 10_000 }

    validates :date,    presence: true

    validates :user_id, presence: true
                        numericality: { only_integer: true }
end
