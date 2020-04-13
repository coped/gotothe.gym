require 'test_helper'

class WorkoutExerciseTest < ActiveSupport::TestCase
  def setup
    @user = users(:first_user)
    @exercise = exercises(:example_exercise)
    @other_exercise = exercises(:other_exercise)
    
    @workout = @user.workouts.create!(
      note: "REMEMBER TO SQUEEZE.",
      date: DateTime.now
    )

    @workout_exercise = WorkoutExercise.create!(
      exercise: @exercise,
      workout: @workout
      )
  end

  test "workout_exercise is valid" do
    assert @workout_exercise.valid?
  end

  test "workout_exercise associated workout should always be present" do
    @workout_exercise.workout = nil
    assert_not @workout_exercise.valid?
  end

  test "workout_exercise associated exercise should always be present" do
    @workout_exercise.exercise = nil
    assert_not @workout_exercise.valid?
  end

  test "exercise should be properly associated with its workout" do
    assert_includes @workout.exercises, @exercise
  end

  test "should be destroyed when workout destroyed" do
    assert_difference -> { WorkoutExercise.count }, -1 do
      @workout.destroy
    end
  end

  test "should be destroyed when exercise destroyed" do
    assert_difference -> { WorkoutExercise.count }, -1 do
      @exercise.destroy
    end
  end

  test "workout_exercise entry should be created when created through an association" do
    assert_difference -> { WorkoutExercise.count }, 1 do
      @workout.exercises << @other_exercise
    end
  end
end
