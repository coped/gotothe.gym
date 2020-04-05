module Api::V1
    class UsersController < ApplicationController
        skip_before_action :is_authorized?, only: [:create]
        before_action :is_current_user?, except: [:create]

        def show
            render json: {
                status: "success",
                messages: {},
                response: {
                    user: @user.basic_details
                }
            }
        end

        def create
            @user = User.new(user_params)
            if @user.save
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
                        errors: @user.errors.messages,
                        error_message: @user.errors.full_messages.to_sentence
                    },
                    response: {}
                }
            end
        end

        def update
            if @user.update(user_params)
                render json: {
                    status: "success",
                    messages: {},
                    response: {
                        user: @user.basic_details
                    }
                }
            else
                render json: {
                    status: "error",
                    messages: {
                        errors: @user.errors.messages,
                        error_message: @user.errors.full_messages.to_sentence
                    },
                    response: {}
                }
            end
        end

        def destroy
            if @user.destroy
                render json: {
                    status: "success",
                    messages: {},
                    response: {}
                }
            else
                render json: {
                    status: "error",
                    messages: {
                        error_message: "Something happened. Please try again."
                    },
                    response: {}
                }
            end
        end

        private

            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation)
            end

            def is_current_user?
                if @current_user.id != params[:id].to_i
                    render json: {
                        status: "error",
                        messages: {
                            error_message: "You're not authorized to view that page."
                        },
                        response: {}
                    }
                else
                    @user = @current_user
                end
            end
    end
end