module Messages
    def self.unauthorized
        {
            type: "warning",
            message: "You're not authorized to do that."
        }
    end

    def self.invalid_credentials
        {
            type: "warning",
            message: "Invalid email or password. Please try again."
        }
    end

    def self.user_errors(user)
        {
            type: "warning",
            message: user.errors.full_messages.join("\n")
        }
    end

    def self.workout_errors(workout)
        {
            type: "warning",
            message: workout.errors.full_messages.join("\n")
        }
    end
end