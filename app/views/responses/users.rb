module Responses
    module Users
        def self.show(user:)
            {
                user: user.basic_details
            }
        end

        def self.create(user:)
            {
                user: user.basic_details,
                jwt: user.generate_jwt
            }
        end

        def self.
    end
end