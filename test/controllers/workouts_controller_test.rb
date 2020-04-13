require 'test_helper'

class Api::WorkoutsControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:first_user)
        @workout = @user.workouts.create!(date: DateTime.now)
        @other_user = users(:second_user)
        @other_user_workout = @other_user.workouts.create!(date: DateTime.now)
        @auth_header = 'Bearer ' + JsonWebToken.encode(payload: { user_id: @user.id })
    end

    test "should succesfully show a workout" do
        get api_v1_workout_path(@workout), headers: { authorization: @auth_header }
        assert_equal 'success', json_response['status']
        assert_includes json_response['payload'], 'workout'
    end

    test "should not show workout to unauthorized user" do
        get api_v1_workout_path(@workout)
        assert_equal 'error', json_response['status']
        assert_nil json_response['payload']
    end

    test "should not show different users workout" do
        get api_v1_workout_path(@other_user_workout), headers: { authorization: @auth_header }
        assert_equal 'error', json_response['status']
        assert_nil json_response['payload']
    end

    test "should successfully create Workout entry" do
        assert_difference -> { Workout.count }, 1 do
            post api_v1_workouts_path, params: { workout: { date: DateTime.now } }, 
                                       headers: { authorization: @auth_header }
        end
        assert_equal 'success', json_response['status']
        assert_includes json_response['payload'], 'workout'
    end

    test "should successfully create WorkoutExercise entries" do
        payload = ["other-exercise-name", "example-exercise-name"]
        assert_difference -> { WorkoutExercise.count }, 2 do
            post api_v1_workouts_path, params: { workout: { date: DateTime.now,
                                                            exercises: payload } }, 
                                       headers: { authorization: @auth_header }
        end
        assert_equal 'success', json_response['status']
        assert json_response['payload']['workout']['exercises'].present?
        assert_equal 2, Workout.last.exercises.count
    end

    test "should not create Workout entry if not logged in" do
        assert_no_difference -> { Workout.count } do
            post api_v1_workouts_path, params: { workout: { date: DateTime.now } }
        end
    end

    test "should not create WorkoutExercise entries if not logged in" do
        payload = ["example-exercise-name", "other-exercise-name"]
        assert_no_difference -> { Workout.count } do
            post api_v1_workouts_path, params: { workout: { date: DateTime.now,
                                                            exercises: payload } }
        end
    end

    test "should successfully update Workout entry" do
        assert_changes -> { @workout.date.to_s } do
            patch api_v1_workout_path(@workout), params: { workout: { date: DateTime.tomorrow } },
                                                 headers: { authorization: @auth_header }
            @workout.reload
        end
        assert_equal 'success', json_response['status']
    end

    test "should successfully update WorkoutExercise entries" do
        payload = ["example-exercise-name", "other-exercise-name"]
        assert_difference -> { WorkoutExercise.count }, 2 do
            patch api_v1_workout_path(@workout), params: { workout: { exercises: payload } },
                                                 headers: { authorization: @auth_header }
        end
        assert_equal 'success', json_response['status']
    end

    test "updating workout exercises should replace exercises, not add" do
        @workout.exercises << exercises(:example_exercise)
        payload = ["other-exercise-name"]
        assert_no_difference -> { @workout.exercises.count } do
            patch api_v1_workout_path(@workout), params: { workout: { exercises: payload } },
                                                 headers: { authorization: @auth_header }
            @workout.reload
        end
        assert_equal 'success', json_response['status']
        assert json_response['payload']['workout']['exercises'].present?
    end

    test "should not update Workout entry if unauthorized" do
        assert_no_changes -> { @workout.date.to_s } do
            patch api_v1_workout_path(@workout), params: { workout: { date: DateTime.tomorrow } }
            @workout.reload
        end
        assert_equal 'error', json_response['status']
    end

    test "should not update WorkoutExercise entries if unauthorized" do
        payload = ["example-exercise-name", "other-exercise-name"]
        assert_no_difference -> { WorkoutExercise.count } do
            patch api_v1_workout_path(@workout), params: { workout: { exercises: payload } }
        end
        assert_equal 'error', json_response['status']
    end

    test "should not update Workout entry if different user" do
        assert_no_changes -> { @workout.date } do
            patch api_v1_workout_path(@other_user_workout), params: { workout: { date: DateTime.tomorrow } },
                                                            headers: { authorization: @auth_header }
        end
        assert_equal 'error', json_response['status']
    end

    test "should not update WorkoutExercise entries if different" do
        payload = ["example-exercise-name", "other-exercise-name"]
        assert_no_difference -> { WorkoutExercise.count } do
            patch api_v1_workout_path(@other_user_workout), params: { workout: { exercises: payload } },
                                                            headers: { authorization: @auth_header }
        end
        assert_equal 'error', json_response['status']
    end

    test "should be destroyed" do
        assert_difference -> { Workout.count }, -1 do
            delete api_v1_workout_path(@workout), headers: { authorization: @auth_header }
        end
        assert_equal 'success', json_response['status']
    end

    test "should not be destroyed if unauthorized" do
        assert_no_difference -> { Workout.count } do
            delete api_v1_workout_path(@workout)
        end
        assert_equal 'error', json_response['status']
    end

    test "should not be destroyed if different user" do
        assert_no_difference -> { Workout.count } do
            delete api_v1_workout_path(@other_user_workout), headers: { authorization: @auth_header }
        end
    end
end
