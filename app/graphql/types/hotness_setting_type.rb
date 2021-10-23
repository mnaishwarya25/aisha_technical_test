module Types
  class HotnessSettingType < Types::BaseObject
    field :temp, Float, null: false
    field :units, Types::TempUnitsType, null: false
  end
end
