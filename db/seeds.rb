5.times do 
    User.create(
        {
            name: Faker::Name.name,
            email: Faker::Internet.email,
            password: "foobar",
            password_confirmation: "foobar"
        }
    )
end