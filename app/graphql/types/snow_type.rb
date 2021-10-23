module Types
  class SnowType < Types::BaseObject
    field :vol_one_hour,  Integer, null: false
    field :vol_three_hours,  Integer, null: false
  end
end
