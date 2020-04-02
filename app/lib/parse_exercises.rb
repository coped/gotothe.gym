module ParseExercises

    # Parse exercise JSON data from lib/exercises
    def self.data
        all_exercises = Rails.root.join('lib', 'exercises')

		return Dir.children(all_exercises).reduce([]) do |total, exercise_dir|
            exercise_files = Dir.children(all_exercises + exercise_dir)
            
            json_file = exercise_files.find { |file| file.include?(".json") }
            
			exercise = JSON.parse(
				File.read(all_exercises + exercise_dir + json_file)
            )
            
			total << exercise
		end
    end
end