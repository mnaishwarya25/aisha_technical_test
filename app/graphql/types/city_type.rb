module Types
  class CityType < Types::BaseObject
    field :coordinates, Types::CoordinatesType, null: false
    field :country, String, null: false
    field :id, Integer, null: false
    field :timezone, Integer, null: false
    field :name, String, null: false
    field :sunrise, String, null: false
    field :sunset, String, null: false
    
    field :timezone, String, null: false
    field :state, String, null: false
    
  end
end
