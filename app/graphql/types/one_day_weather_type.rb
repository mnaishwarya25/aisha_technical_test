module Types
  class OneDayWeatherType < Types::BaseObject
    field :lat, Float, null: false
    field :lon, Float, null: false
    field :cloud_per, Integer, null: false
    field :cloud_feel_sike, Float, null: false
    field :ground_level, Integer, null: true
    field :hot, Boolean, null: false
    field :humidity, Integer, null: false
    field :pressure, Integer, null: true
    field :rain, Types::RainType, null: true
    field :wind, Types::WindType, null: true
    field :snow, Types::SnowType, null: true
    field :seaLevel, Integer, null: true
    field :temp, Float, null: false
    field :temp_max, Float, null: false
    field :temp_min, Float, null: false
    field :visibility, Integer, null: false
    field :weather_description, Types::WeatherDescriptionType, null: true

    field :feels_like, Boolean, null: false
  end
end
