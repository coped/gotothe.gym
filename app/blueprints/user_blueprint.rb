class UserBlueprint < Blueprinter::Base
    view :basic_details do
        identifier :id
        fields :name, :email
    end
end