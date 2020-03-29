class Exercise < ApplicationRecord
	# === Associations ====
	has_many :exercise_muscle_groups
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
                                        
	validates :primer,                  presence: true,
                                        length: { maximum: 500 }
                                        
	validates :movement_type,           presence: true,
                                        length: { maximum: 255 }
                                        
	validates :equipment,               presence: true,
                                        length: { maximum: 255 }
                                        
    validates :secondary_muscle_groups, length: { maximum: 255 }
    
	validates :steps,                   presence: true,
                                        length: { maximum: 10_000 }
                                        
	validates :tips,                    length: { maximum: 500 }

	# === Class methods ===

	# Parse exercise data from lib/exercises
	def self.parsed_exercises(exercises = Rails.root.join('lib', 'exercises'))
		return Dir.children(exercises).reduce([]) do |total, exercise_dir|
			exercise_files = Dir.children(exercises + exercise_dir)
			json = exercise_files.find { |file| file.include?(".json") }
			exercise = JSON.parse(
				File.read(exercises + exercise_dir + json)
			)
			total << exercise
		end
	end
end
