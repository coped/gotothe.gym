class AuthorizeApiRequest
    attr_reader :headers

    def initialize(headers = {})
        @headers = headers
    end

    def call
        user
    end

    private

        def user
            begin
                @user ||= User.find_by(id: decoded_token["user_id"]) if decoded_token
            rescue Exception => e
                p e
            end
        end

        def decoded_token
            begin
                @decoded_token ||= JsonWebToken.decode(http_auth_header)
            rescue Exception => e
                p e
                nil
            end
        end

        def http_auth_header
            if headers["Authorization"].present?
                return headers["Authorization"].split(" ").last
            end
        end
end