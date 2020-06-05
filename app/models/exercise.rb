class Exercise < ApplicationRecord
	# Override to_param to use Exercise name as URL identifier, and in path constructors
	def to_param
		name
	end

	# === Associations ====
	has_many :workout_exercises, dependent: :destroy
	has_many :exercise_muscle_groups, dependent: :destroy
	has_many :muscle_groups, through: :exercise_muscle_groups

	# === Validations ===
	validates :image_id,                presence: true,
										length: { is: 4 },
                                        numericality: { only_integer: true }
                                        
	validates :name,                    presence: true,
										length: { maximum: 255 },
                                        uniqueness: true
                                        
	validates :title,                   presence: true,
                                        length: { maximum: 255 }
                                        
	validates :primer,                  length: { maximum: 500 }
                                        
	validates :movement_type,           presence: true,
                                        length: { maximum: 255 }
                                        
	validates :equipment,               presence: true,
                                        length: { maximum: 255 }
                                        
    validates :secondary_muscle_groups, length: { maximum: 255 }
    
	validates :steps,                   presence: true,
                                        length: { maximum: 10_000 }
                                        
	validates :tips,                    length: { maximum: 500 }

	# === Instance methods ===
	def details
		ExerciseBlueprint.render_as_hash(
			self,
			view: :all_details,
			root: :exercise
		)
	end

	def self.all_exercises
		ExerciseBlueprint.render_as_hash(
			Exercise.all.includes(:muscle_groups),
			view: :all_details,
			root: :exercises
		)
	end
end
