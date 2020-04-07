require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  def setup
    @exercise = exercises(:example_exercise)
  end

  test "is valid" do
    assert @exercise.valid?
  end

  test "image_id should always be present" do
    @exercise.image_id = ""
    assert_not @exercise.valid?
  end

  test "image_id should be four characters long" do
    @exercise.image_id = "00005"
    assert_not @exercise.valid?
  end

  test "image_id should only consist of numbers" do
    @exercise.image_id = "0zero04"
    assert_not @exercise.valid?
  end

  test "image_id should not accept improper formats" do
    @exercise.image_id = 0001 # becomes "1" when stringified
    assert_not @exercise.valid?
  end

  test "name should always be present" do
    @exercise.name = ""
    assert_not @exercise.valid?
  end

  test "name should not exceed maximum string length of 255 characters" do
    @exercise.name = "e" * 256
    assert_not @exercise.valid?
  end

  test "name should be unique" do
    other_exercise = exercises(:other_exercise)
    @exercise.name = other_exercise.name
    assert_not @exercise.valid?
  end

  test "primer should not exceed maximum character length of 500 characters" do
    @exercise.primer = "e" * 501
    assert_not @exercise.valid?
  end

  test "movement_type should always be present" do
    @exercise.movement_type = ""
    assert_not @exercise.valid?
  end

  test "movement_type should not exceed maximum string length of 255 characters" do
    @exercise.movement_type = "e" * 256
    assert_not @exercise.valid?
  end

  test "equipment should always be present" do
    @exercise.equipment = ""
    assert_not @exercise.valid?
  end
  
  test "equipment should not exceed maximum string length of 255 characters" do
    @exercise.equipment = "e" * 256
    assert_not @exercise.valid?
  end

  test "secondary_muscle_groups should not exceed maximum string length of 255 characters" do
    @exercise.secondary_muscle_groups = "e" * 256
    assert_not @exercise.valid?
  end

  test "steps should always be present" do
    @exercise.steps = ""
    assert_not @exercise.valid?
  end

  test "steps should not exceed maximum character length of 10_000" do
    @exercise.steps = "e" * 10_001
    assert_not @exercise.valid?
  end

  test "tips should not exceed maximum character length of 500" do
    @exercise.tips = "e" * 501
    assert_not @exercise.valid?
  end
end
