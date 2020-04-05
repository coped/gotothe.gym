module Api::V1
    class AuthController < ApplicationController
        skip_before_action :is_authorized?, only: [:create]

        def create
            @user = User.find_by(email: login_params[:email])
            if @user && @user.authenticate(login_params[:password])
                render json: {
                    status: "success",
                    messages: {},
                    response: {
                        user: @user.basic_details,
                        jwt: @user.generate_jwt
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

        def destroy
            render json: {
                status: "success",
                messages: {},
                response: {}
            }
        end

        private

            def login_params
                params.require(:login).permit(:email, :password)
            end
    end
end