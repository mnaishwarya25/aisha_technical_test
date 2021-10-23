module Types
  class RainType < Types::BaseObject
    field :vol_one_hour, Integer, null: false
    field :vol_three_hours, Integer, null: true
  end 
end
