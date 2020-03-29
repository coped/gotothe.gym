class Workout < ApplicationRecord
    # === Associations ===
    belongs_to :user
    has_many :workout_exercises
    has_many :exercises, through: :workout_exercises

    # === Validations ===
    validates_presence_of :user

    validates :note,    length: { maximum: 10_000 }

    validates :date,    presence: true
end
