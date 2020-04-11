module Api::V1
    class UsersController < ApplicationController
        skip_before_action :is_authorized?, only: [:create]
        before_action :is_current_user?, except: [:create]

        def show
            json = ApiResponse.build_json(
                payload: @user.basic_details
            )
            render json: json, status: :ok
        end

        def create
            @user = User.new(user_params)
            if @user.save
                json = ApiResponse.build_json(
                    payload: @user.basic_details(with_jwt: true)
                )
                render json: json, status: :ok
            else
                messages = [Messages.user_errors(@user)]
                json = ApiResponse.build_json(
                    error: true, 
                    messages: messages
                )
                render json: json, status: :bad_request
            end
        end

        def update
            if @user.update(user_params)
                json = ApiResponse.build_json(
                    payload: @user.basic_details
                )
                render json: json, status: :ok
            else
                messages = [Messages.user_errors(@user)]
                json = ApiResponse.build_json(
                    error: true,
                    messages: messages
                )
                render json: json, status: :bad_request
            end
        end

        def destroy
            if @user.destroy
                render json: ApiResponse.build_json
            else
                messages = [Messages.destroy_error]
                json = ApiResponse.build_json(
                    error: true,
                    messages: messages
                )
                render json: json, status: :internal_server_error
            end
        end

        private

            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation)
            end

            def is_current_user?
                if @current_user.id != params[:id].to_i
                    messages = [Messages.unauthorized]
                    json = ApiResponse.build_json(
                        error: true,
                        messages: messages
                    )
                    render json: json, status: :unauthorized
                else
                    @user = @current_user
                end
            end
    end
end