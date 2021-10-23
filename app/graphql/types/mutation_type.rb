module Types
  class MutationType < Types::BaseObject
    field :hotness_setting, mutation: Mutations::UpdateHotnessSettings
  end
end
