module Api::V1
    class AuthController < ApplicationController
        skip_before_action :require_login, only: [:create]

        def create
            @user = User.find_by(email: login_params[:email])
            if @user && @user.authenticate(login_params[:password])

                token = encode_token({ user_id: @user.id })
                user_details = UserBlueprint.render_as_hash(@user)

                render json: {
                    status: "success",
                    messages: {},
                    response: {
                        user: user_details,
                        jwt: token
                    }
                }
            else
                render json: {
                    status: "error",
                    messages: {
                        error_message: "Invalid email or password."
                    },
                    response: {}
                }
            end
        end

        def auto_login
            if session_user
                render json: { 
                    status: "success",
                    messages: {},
                    response: {}
                }
            else
                render json: { 
                    status: "error",
                    messages: {
                        error_message: "Not logged in."
                    },
                    response: {}
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