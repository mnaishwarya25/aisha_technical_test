module Types
  class CoordinatesType < Types::BaseObject
    field :lat, Float, null: false
    field :lon, Float, null: false
  end
end
