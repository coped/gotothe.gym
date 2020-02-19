module Api::V1
    class UsersController < ApplicationController
        skip_before_action :require_login, only: [:create]
        before_action :is_current_user?, except: [:create]

        def show
            render json: {
                success: true,
                user: @user
            }
        end

        def create
            @user = User.new(user_params)
            if @user.save
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
                    errors: @user.errors.messages,
                    error_message: @user.errors.full_messages.to_sentence
                }
            end
        end

        def update
            if @user.update(user_params)
                render json: {
                    success: true,
                    user: @user
                }
            else
                render json: {
                    success: false,
                    errors: @user.errors.messages,
                    error_message: @user.errors.full_messages.to_sentence
                }
            end
        end

        def destroy
            if @user.destroy
                render json: {
                    success: true
                }
            else
                render json: {
                    success: false,
                    error_message: "Something happened. Please try again."
                }
            end
        end

        private

            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation)
            end

            def is_current_user?
                @user = User.find_by(id: params[:id])
                if session_user != @user
                    render json: {
                        success: false,
                        error_message: "You're not authorized to view that page."
                    }
                end
            end
    end
end