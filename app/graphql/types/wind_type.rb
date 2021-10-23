module Types
  class WindType < Types::BaseObject
    field :degrees, Integer, null: false
    field :gust_speed, Float, null: false
    field :speed, Float, null: false
  end
end
