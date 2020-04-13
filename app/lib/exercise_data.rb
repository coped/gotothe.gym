class ExerciseData
    include ParseExercises
    attr_reader :exercises

    def initialize
        # Parse the exercise data located in lib/exercises.
        # The 'parse_exercises' method is provided by ParseExercises module 
        # found in app/lib/parse_exercises.rb
        @exercises = parse_exercises
    end
    
    def seed
        seed_muscle_groups
        seed_exercises
        true
    end
    
    private 
        
        def seed_muscle_groups
            muscle_groups.each do |muscle_group|
                MuscleGroup.create!(
                    name: muscle_group
                )
            end
        end

        def seed_exercises
            @exercises.each do |exercise|
                new_exercise = Exercise.create!(
                    image_id: exercise["id"],
                    name: exercise["name"],
                    title: exercise["title"],
                    primer: exercise["primer"],
                    movement_type: exercise["type"],
                    equipment: exercise["equipment"].join("\n"),
                    secondary_muscle_groups: exercise["secondary"].join("\n"),
                    steps: exercise["steps"].join("\n"),
                    tips: exercise["tips"].join("\n")
                )

                associate_exercise_with_muscle_groups(
                    muscle_groups: exercise["primary"],
                    new_exercise: new_exercise
                )
            end
        end
    
        def muscle_groups
            @exercises.reduce([]) do |total, exercise|
                exercise["primary"].each do |group|
                    total << group if !total.include?(group)
                end
                total
            end
        end


        def associate_exercise_with_muscle_groups(muscle_groups:, new_exercise:)
            muscle_groups.each do |muscle_group|
                new_exercise.muscle_groups << MuscleGroup.find_by(name: muscle_group)
            end
        end
end