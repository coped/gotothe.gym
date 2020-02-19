module Api::V1
    class AuthController < ApplicationController
        skip_before_action :require_login, only: [:create]

        def create
            @user = User.find_by(email: login_params[:email])
            if @user && @user.authenticate(login_params[:password])
                payload = { user_id: @user.id }
                token = encode_token(payload)
                render json: {
                    success: true,
                    user: @user,
                    jwt: token
                }
            else
                render json: {
                    success: false,
                    error_message: "Invalid email or password."
                }
            end
        end

        def auto_login
            if session_user
                render json: { 
                    success: true
                }
            else
                render json: { 
                    success: false,
                    error_message: "Not logged in."
                }
            end
        end

        def logout
            @session_user = nil
        end

        private

            def login_params
                params.require(:login).permit(:email, :password)
            end
    end
end