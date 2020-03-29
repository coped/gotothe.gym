require 'test_helper'

class WorkoutTest < ActiveSupport::TestCase
  def setup
    @user = users(:first_user)
    @workout = @user.workouts.create!(
      note: "REMEMBER TO SQUEEZE.",
      date: DateTime.now
    )
  end

  test "workout is valid" do
    assert @workout.valid?
  end

  test "workout associated user should always be present" do
    @workout.user = nil
    assert_not @workout.valid?
  end

  test "workout note should not exceed character limit of 10_000" do
    @workout.note = "e" * 10_001
    assert_not @workout.valid?
  end

  test "workout date should always be present" do
    @workout.date = nil
    assert_not @workout.valid?
  end
end
