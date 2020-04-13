module Api::V1
    class WorkoutsController < ApplicationController
        before_action :workout_belongs_to_user?, except: [:create]

        def show
            json = ApiResponse.json(
                payload: @workout.basic_details
            )
            render json: json, status: :ok
        end

        def create
            @new_workout = @current_user.workouts.build(workout_params)
            if @new_workout.save
                json = ApiResponse.json(
                    payload: @new_workout.basic_details
                )
                render json: json, status: :ok
            else
                messages = [Messages.workout_errors(@new_workout)]
                json = ApiResponse.json(
                    error: true,
                    messages: messages
                )
                render json: json, status: :bad_request
            end
        end

        def update
            if @workout.update(workout_params)
                json = ApiResponse.json(
                    payload: @workout.basic_details
                )
                render json: json, status: :ok
            else
                messages = [Messages.workout_errors(@workout)]
                json = ApiResponse.json(
                    error: true,
                    messages: messages
                )
                render json: json, status: :bad_request
            end
        end

        def destroy
            @workout.destroy
            json = ApiResponse.json
            render json: json, status: :ok
        end

        private 

            def workout_belongs_to_user?
                @workout = Workout.find_by(id: params[:id])
                if @current_user.id != @workout.user_id
                    messages = [Messages.unauthorized]
                    json = ApiResponse.json(
                        error: true,
                        messages: messages
                    )
                    return render json: json, status: :unauthorized
                end
            end

            def strong_params
                params.require(:workout).permit(:note, :date, :exercises => [])
            end

            def workout_params
                tmp = {}
                tmp[:note] = strong_params[:note] if strong_params[:note]
                tmp[:date] = DateTime.parse(strong_params[:date]) if strong_params[:date]
                if strong_params[:exercises].present?
                    tmp[:exercises] = find_exercises(strong_params[:exercises]) 
                end
                tmp
            end

            def find_exercises(exercise_names)
                if exercise_names.empty?
                    []
                else
                    Exercise.where(name: exercise_names)
                end
            end
    end
end
