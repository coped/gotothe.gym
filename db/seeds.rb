# Create mock user data in database
User.create(
    name: "First User",
    email: "first@user.com",
    password: "foobar",
    password_confirmation: "foobar"
)

5.times do 
    User.create(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: "foobar",
        password_confirmation: "foobar"
    )
end

# Seed exercise data from lib/exercises
exercises = Exercise.parsed_exercises

muscle_groups = exercises.reduce([]) do |total, exercise|
    exercise["primary"].each do |group|
        total << group if !total.include?(group)
    end
    total
end

muscle_groups.each do |muscle_group|
    MuscleGroup.create(
        name: muscle_group
    )
end

exercises.each do |exercise|
    new_exercise = Exercise.create(
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
    exercise["primary"].each do |muscle_group|
        new_exercise.muscle_groups << MuscleGroup.find_by(name: muscle_group)
    end
end