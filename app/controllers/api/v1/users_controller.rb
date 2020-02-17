module Api::V1
    class UsersController < ApplicationController
        before_action :get_user, only: [:show, :update, :destroy]

        def index
            render json: User.all
        end

        def show
            if @user = User.find_by(id: params[:id])
                render json: {
                    success: true,
                    user: @user
                }
            else
                render json: {
                    success: false,
                    error_message: "User doesn't exist."
                }
            end
        end

        def create
            @user = User.new(user_params)
            if @user.save
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

        def update
            @user = User.find_by(id: params[:id])
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
            @user = User.find_by(id: params[:user_id])
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

        private

            def get_user
                @user = User.find_by(id: params[:id])
            end

            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation)
            end
    end
end