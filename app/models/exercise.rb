class Exercise < ApplicationRecord
        # === Associations ====
        has_many :muscle_groups, through: :exercise_muscle_groups

        # === Validations ===
        validates :image_id,                presence: true,
                                            length: { maximum: 4 },
                                            numericality: { only_integer: true }
        validates :name,                    presence: true,
                                            length: { maximum: 255 },
                                            uniqueness: true
        validates :title,                   presence: true,
                                            length: { maximum: 255 }
        validates :primer,                  presence: true,
                                            length: { maximum: 500 }
        validates :type,                    presence: true,
                                            length: { maximum: 255 }
        validates :equipment,               presence: true,
                                            length: { maximum: 255 }
        validates :secondary_muscle_groups, presence: true,
                                            length: { maximum: 255 }
        validates :steps,                   presence: true,
                                            length: { maximum: 10_000}
        validates :tips,                    presence: true,
                                            length: { maximum: 500 }

        # === Scopes ===

        # === Instance methods ===

        # === Class methods ===


end
