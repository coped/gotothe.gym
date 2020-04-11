module ParseExercises
    private
    
        def main_directory
            Rails.root.join('lib', 'exercises')
        end

        def get_data
            all_exercises.reduce([]) do |total, exercise_dir|
                json_file = find_json_file(files: files_in(directory: exercise_dir))
                
                exercise = JSON.parse(
                    file_contents(directory: exercise_dir, file: json_file)
                )
                total << exercise
            end
        end

        def all_exercises
            Dir.children(
                main_directory
            )
        end

        def files_in(directory:)
            Dir.children(main_directory + directory)
        end

        def find_json_file(files:)
            files.find { |file| file.include?(".json") }
        end

        def file_contents(directory:, file:)
            File.read(main_directory + directory + file)
        end
end
