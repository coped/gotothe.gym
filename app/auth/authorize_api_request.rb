class AuthorizeApiRequest
    attr_reader :headers

    def initialize(headers: {})
        @headers = headers
    end
    
    # Entry point for service object - Find and return user from JWT payload
    def call
        user
    end

    private

        def user
            (decoded_token) ? @user ||= User.find_by(id: decoded_token["user_id"]) : nil
        end

        def decoded_token
            begin
                @decoded_token ||= JsonWebToken.decode(token: http_auth_header)
            rescue Exception => e
                nil
            end
        end

        def http_auth_header
            begin
                if headers["Authorization"].present?
                    headers["Authorization"].split(" ").last
                end
            rescue Exception => e
                nil
            end
        end
end