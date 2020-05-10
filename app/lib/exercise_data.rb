class ExerciseData
    include ParseFiles
    
    def seed
        seed_all_muscle_groups
        seed_all_exercises
        true
    end

    def exercises
        @exercises ||= structify(parsed_exercises)
    end

    private

        def parsed_exercises
            main_dir = Rails.root.join('lib', 'exercises')
            files_in(main_dir).reduce([]) do |total, exercise_dir|
                json_file = find_json_file(files_in(main_dir + exercise_dir))
                
                exercise = JSON.parse(
                    file_contents(main_dir + exercise_dir + json_file)
                )
                total << exercise
            end
        end
        
        ExerciseStruct = Struct.new(
            :id,
            :name,
            :title,
            :primer,
            :type,
            :equipment,
            :primary,
            :secondary,
            :steps,
            :tips,
        )

        def structify(exercises)
            exercises.map do |exercise|
                ExerciseStruct.new(
                    exercise["id"],
                    exercise["name"],
                    exercise["title"],
                    exercise["primer"],
                    exercise["type"],
                    exercise["equipment"],
                    exercise["primary"],
                    exercise["secondary"],
                    exercise["steps"],
                    exercise["tips"]
                )
            end
        end
        
        def seed_all_muscle_groups
            all_muscle_groups.each do |muscle_group|
                MuscleGroup.create!(
                    name: muscle_group
                )
            end
        end

        def seed_all_exercises
            exercises.each do |exercise|
                seed_and_associate(exercise)
            end
        end

        def seed_and_associate(exercise)
            new_exercise = Exercise.create!(
                image_id: exercise.id,
                name: exercise.name,
                title: exercise.title,
                primer: exercise.primer,
                movement_type: exercise.type,
                equipment: exercise.equipment.join("\n"),
                secondary_muscle_groups: exercise.secondary.join("\n"),
                steps: exercise.steps.join("\n"),
                tips: exercise.tips.join("\n")
            )

            associate_exercise_with_muscle_groups(
                muscle_groups: exercise.primary,
                new_exercise: new_exercise
            )
        end
    
        def all_muscle_groups
            exercises.reduce([]) do |total, exercise|
                exercise.primary.each do |group|
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