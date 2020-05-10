class ApiRequest
    attr_reader :request
    def initialize(request)
        @request = request
    end

    # Find and return user from JWT payload
    def authorize
        user
    end

    private

        def user
            @user ||= (decoded_token) ? User.find_by(id: decoded_token["user_id"]) : nil
        end

        def decoded_token
            begin
                @decoded_token ||= JsonWebToken.decode(token: http_auth_header)
            rescue Exception => e
                nil
            end
        end

        def headers
            request.headers
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