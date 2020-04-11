class ExerciseData
    extend ParseExercises

    def self.parse
        begin
            @data ||= get_data
        rescue Exception => e
            p e if !Rails.env.test?
            nil
        end
    end

    def self.seed(exercises:)
        begin
            @exercises = exercises
            seed_muscle_groups
            seed_exercises
            true
        rescue Exception => e
            p e if !Rails.env.test?
            nil
        end
    end

    private 

        def self.muscle_groups
            @exercises.reduce([]) do |total, exercise|
                exercise["primary"].each do |group|
                    total << group if !total.include?(group)
                end
                total
            end
        end

        def self.seed_muscle_groups
            muscle_groups.each do |muscle_group|
                MuscleGroup.create!(
                    name: muscle_group
                )
            end
        end

        def self.seed_exercises
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

        def self.associate_exercise_with_muscle_groups(muscle_groups:, new_exercise:)
            muscle_groups.each do |muscle_group|
                new_exercise.muscle_groups << MuscleGroup.find_by(name: muscle_group)
            end
        end
end