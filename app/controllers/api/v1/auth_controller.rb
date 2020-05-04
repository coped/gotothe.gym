module Api::V1
    class AuthController < ApplicationController
        skip_before_action :require_authorization, only: [:create]

        def create
            @user = User.find_by(email: login_params[:email])
            if @user && @user.authenticate(login_params[:password])
                json = ApiResponse.json(payload: @user.dashboard_details(with_jwt: true))
                render json: json, status: :ok
            else
                messages = [Messages.invalid_credentials]
                json = ApiResponse.json(error: true, messages: messages)
                render json: json, status: :unauthorized
            end
        end

        def destroy
            @current_user = nil
            render json: ApiResponse.json, status: :ok
        end

        private

            def login_params
                params.require(:login).permit(:email, :password)
            end
    end
end