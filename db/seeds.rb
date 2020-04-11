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

# Parse exercise data from lib/exercises
exercises = ExerciseData.parse

# Seed exercise data to database
ExerciseData.seed(exercises: exercises)
