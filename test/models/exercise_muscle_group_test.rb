require 'test_helper'

class ExerciseMuscleGroupTest < ActiveSupport::TestCase
  def setup
    @exercise = exercises(:example_exercise)
    @muscle_group = MuscleGroup.create!(name: "deltoid")
    @exercise_muscle_group = ExerciseMuscleGroup.create!(
      exercise: @exercise,
      muscle_group: @muscle_group
    )
  end

  test "exercise_muscle_group should be valid" do
    assert @exercise_muscle_group.valid?
  end

  test "exercise_muscle_group associated exercise should always be present" do
    @exercise_muscle_group.exercise = nil
    assert_not @exercise_muscle_group.valid?
  end

  test "exercise_muscle_group associated muscle_group should always be present" do
    @exercise_muscle_group.muscle_group = nil
    assert_not @exercise_muscle_group.valid?
  end

  test "muscle_group should be properly associated with its exercise" do
    assert_includes @exercise.muscle_groups, @muscle_group
  end

  test "exercise should be properly associated with its muscle group" do
    assert_includes @muscle_group.exercises, @exercise
  end

  test "exercise_muscle_group entry should be created when created through association" do
    assert_difference -> { ExerciseMuscleGroup.count }, 1 do
      @exercise.muscle_groups << @muscle_group
    end
    assert_difference -> { ExerciseMuscleGroup.count }, 1 do
      @muscle_group.exercises << @exercise
    end
  end

  test "should be destroyed when muscle group destroyed" do
    assert_difference -> { ExerciseMuscleGroup.count }, -1 do
      @muscle_group.destroy
    end
  end

  test "should be destroyed when exercise destroyed" do
    assert_difference -> { ExerciseMuscleGroup.count }, -1 do
      @exercise.destroy
    end
  end
end
