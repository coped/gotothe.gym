module Api::V1
    class AuthController < ApplicationController
        skip_before_action :is_authorized?, only: [:create]

        def create
            @user = User.find_by(email: login_params[:email])
            if @user && @user.authenticate(login_params[:password])
                json = JsonResponse.new(payload: @user.basic_details(with_jwt: true))
                render json: json.response, status: :ok
            else
                messages = ["Invalid email or password."]
                json = JsonResponse.new(error: true, messages: messages)
                render json: json.response, status: :unauthorized
            end
        end

        def destroy
            render json: JsonResponse.new.response, status: :ok
        end

        private

            def login_params
                params.require(:login).permit(:email, :password)
            end
    end
end