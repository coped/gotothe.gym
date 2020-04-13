module Messages
    def self.unauthorized
        HashWithIndifferentAccess.new(
            {
                type: "warning",
                message: "You're not authorized to do that."
            }
        )
    end

    def self.invalid_credentials
        HashWithIndifferentAccess.new(
            {
                type: "warning",
                message: "Invalid email or password. Please try again."
            }
        )
    end

    def self.user_errors(user)
        if user.errors.present?
            HashWithIndifferentAccess.new(
                {
                    type: "warning",
                    message: user.errors.full_messages.to_sentence
                }
            )
        else
            raise ArgumentError, "User has no errors present."
        end
    end

    def self.workout_errors(workout)
        if workout.errors.present?
            HashWithIndifferentAccess.new(
                {
                    type: "warning",
                    message: workout.errors.full_messages.to_sentence
                }
            )
        else
            raise ArgumentError, "Workout has no errors present."
        end
    end
end