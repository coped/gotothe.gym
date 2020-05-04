class UserBlueprint < Blueprinter::Base
    view :basic_details do
        identifier :id
        fields :name, :email
    end

    view :dashboard_details do
        include_view :basic_details
        association :workouts, blueprint: WorkoutBlueprint, view: :basic_details
    end
end