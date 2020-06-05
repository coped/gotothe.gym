class WorkoutBlueprint < Blueprinter::Base
    identifier :id
    fields :date, :note
    association :exercises, blueprint: ExerciseBlueprint, view: :all_details
end