module Api::V1
    class AuthController < ApplicationController
        skip_before_action :is_authorized?, only: [:create]

        def create
            @user = User.find_by(email: login_params[:email])
            if @user && @user.authenticate(login_params[:password])

                token = JsonWebToken.encode({ user_id: @user.id })
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