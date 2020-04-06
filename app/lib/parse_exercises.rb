class ParseExercises
    def initialize(starting_directory: Rails.root.join('lib', 'exercises'))
        @starting_directory = starting_directory
    end

    # Parse exercise JSON data from lib/exercises
    def call
        begin
            data
        rescue Exception => e
            p e if Rails.env.development?
            nil
        end
    end

    private

        def data
            @data ||= all_exercises.reduce([]) do |total, exercise_dir|
                json_file = find_json_file(files: files_in(directory: exercise_dir))
                
                exercise = JSON.parse(
                    file_contents(directory: exercise_dir, file: json_file)
                )
                
                total << exercise
            end
        end

        def all_exercises
            Dir.children(
                @starting_directory
            )
        end

        def files_in(directory:)
            Dir.children(@starting_directory + directory)
        end

        def find_json_file(files:)
            files.find { |file| file.include?(".json") }
        end

        def file_contents(directory:, file:)
            File.read(@starting_directory + directory + file)
        end
end