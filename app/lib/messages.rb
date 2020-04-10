module Messages
    def self.unauthorized
        HashWithIndifferentAccess.new(
            {
                type: "warning",
                message: "You're not authorized to view that page."
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
            raise ArgumentError, "User has no errors"
        end
    end

    def self.destroy_error
        HashWithIndifferentAccess.new(
            {
                type: "warning",
                message: "Something happened when trying to delete the account. Please try again."
            }
        )
    end
end