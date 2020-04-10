module Api::V1
    class UsersController < ApplicationController
        skip_before_action :is_authorized?, only: [:create]
        before_action :is_current_user?, except: [:create]

        def show
            json = JsonResponse.new(
                payload: @user.basic_details
            )
            render json: json.response, status: :ok
        end

        def create
            @user = User.new(user_params)
            if @user.save
                json = JsonResponse.new(
                    payload: @user.basic_details(with_jwt: true)
                )
                render json: json.response, status: :ok
            else
                messages = [Messages.user_errors(@user)]
                json = JsonResponse.new(
                    error: true, 
                    messages: messages
                )
                render json: json.response, status: :bad_request
            end
        end

        def update
            if @user.update(user_params)
                json = JsonResponse.new(
                    payload: @user.basic_details
                )
                render json: json.response, status: :ok
            else
                messages = [Messages.user_errors(@user)]
                json = JsonResponse.new(
                    error: true,
                    messages: messages
                )
                render json: json.response, status: :bad_request
            end
        end

        def destroy
            if @user.destroy
                render json: JsonResponse.new.response
            else
                messages = [Messages.destroy_error]
                json = JsonResponse.new(
                    error: true,
                    messages: messages
                )
                render json: json.response, status: :internal_server_error
            end
        end

        private

            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation)
            end

            def is_current_user?
                if @current_user.id != params[:id].to_i
                    messages = [Messages.unauthorized]
                    json = JsonResponse.new(
                        error: true,
                        messages: messages
                    )
                    render json: json.response, status: :unauthorized
                else
                    @user = @current_user
                end
            end
    end
end