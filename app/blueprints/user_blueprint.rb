class UserBlueprint < Blueprinter::Base
    identifier :id
    fields :name, :email

    view :dashboard_details do
        association :workouts, blueprint: WorkoutBlueprint
    end
end