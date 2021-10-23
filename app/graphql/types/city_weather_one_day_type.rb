module Types
  class CityWeatherOneDayType < Types::BaseObject
    field :city, Types::CityType, null: false
    field :weather, Types::OneDayWeatherType, null: false
  end
end
