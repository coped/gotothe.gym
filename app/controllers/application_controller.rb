class ApplicationController < ActionController::API
    before_action :require_login

    def encode_token(payload)
        JWT.encode(payload, ENV['JWT_SECRET'])
    end

    def decoded_token
        auth_header = request.headers['Authorization']
        if auth_header
            token = auth_header.split(" ").last
            begin
                JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: "HS256")
            rescue JWT::DecodeError
                []
            end
        end
    end

    def session_user
        decoded_hash = decoded_token
        if decoded_hash.present?
            user_id = decoded_hash[0]['user_id']
            @session_user ||= User.find_by(id: user_id)
        else
            nil
        end
    end

    def logged_in?
        !!session_user
    end

    def require_login
        if !logged_in?
            render json: {
                status: "error", 
                messages: {
                    error_message: "Not logged in"
                },
                response: {}
            }, 
            status: :unauthorized
        end
    end
end
