require 'test_helper'

class WorkoutsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_user)
    @user_auth_header = auth_header(@user)
    @other_user = users(:second_user)
    @exercise = exercises(:example_exercise)
    @other_exercise = exercises(:other_exercise)
  end

  test "workouts interface" do
    # Starting point, showing a user
    get api_v1_user_path(@user), headers: @user_auth_header
    assert_equal 'success', json_response['status']
    # === Creating workout entries ===
    # Should fail without authorization
    post api_v1_workouts_path, params: { workout: { date: DateTime.now } }
    assert_equal 'error', json_response['status']
    assert json_response['messages'].present?
    assert_nil json_response['payload']
    # Should succeed
    post api_v1_workouts_path, params: { workout: { date: DateTime.now } },
                               headers: @user_auth_header
    user_workout_without_exercises = Workout.last
    assert_equal 'success', json_response['status']
    assert_includes json_response['payload'], 'workout'
    assert_empty json_response['payload']['workout']['exercises']
    # Should succeed and associate exercises with workout
    post api_v1_workouts_path, params: { workout: { date: DateTime.now,
                                                    exercises: [
                                                      @exercise.name
                                                    ] } },
                               headers: @user_auth_header
    user_workout_with_exercises = Workout.last
    assert_equal 'success', json_response['status']
    assert_equal 1, json_response['payload']['workout']['exercises'].count
    # === Updating workout entries ===
    # Update should fail if unauthorized
    patch api_v1_workout_path(user_workout_with_exercises), params: { date: DateTime.tomorrow }
    assert_equal 'error', json_response['status']
    assert json_response['messages'].present?
    assert_nil json_response['payload']
    patch api_v1_workout_path(user_workout_with_exercises), params: { 
      date: DateTime.tomorrow 
    }
    # Update should fail if different user
    patch api_v1_workout_path(user_workout_with_exercises), params: { 
      workout: { date: DateTime.tomorrow } 
    }, headers: auth_header(@other_user)
    assert_equal 'error', json_response['status']
    assert json_response['messages'].present?
    assert_nil json_response['payload']
    # Update should succeed (additionally, not providing an exercise param should not delete exercises)
    patch api_v1_workout_path(user_workout_with_exercises), params: { 
      workout: { date: DateTime.tomorrow } 
    }, headers: @user_auth_header
    assert_equal 'success', json_response['status']
    assert_equal 1, json_response['payload']['workout']['exercises'].count
    # Should replace exercise
    patch api_v1_workout_path(user_workout_with_exercises), params: { 
      workout: { exercises: [
        @other_exercise.name
      ] } 
    }, headers: @user_auth_header
    assert_equal 'success', json_response['status']
    assert_equal 1, json_response['payload']['workout']['exercises'].count
    # Providing empty exercise param should remove exercises
    patch api_v1_workout_path(user_workout_with_exercises), params: { 
      workout: { exercises: [] } 
    }, headers: @user_auth_header
    assert_equal 'success', json_response['status']
    assert_empty json_response['payload']['workout']['exercises']
    # === Destroying workout entries ===
    # Should not destroy if unauthorized
    delete api_v1_workout_path(user_workout_with_exercises)
    assert_equal 'error', json_response['status']
    # Should not destroy if different user
    delete api_v1_workout_path(user_workout_with_exercises), headers: auth_header(@other_user)
    assert_equal 'error', json_response['status']
    # Should destroy
    delete api_v1_workout_path(user_workout_with_exercises), headers: @user_auth_header
    assert_equal 'success', json_response['status']
  end
end
