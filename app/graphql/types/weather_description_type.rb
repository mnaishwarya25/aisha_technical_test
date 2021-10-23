module Types
  class WeatherDescriptionType < Types::BaseObject
    field :description, String, null: false
    field :icon_code, String, null: false
    field :id, Integer, null: false
    field :main, String, null: false
  end
end
