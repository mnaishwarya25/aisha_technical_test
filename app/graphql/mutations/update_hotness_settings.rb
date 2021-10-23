require 'json'
class Mutations::UpdateHotnessSettings < Mutations::BaseMutation
    argument :temp, Float, required: true
    argument :units, Types::TempUnitsType, required: false

    field :hotness_setting, Types::HotnessSettingType, null: false
    
    def resolve(temp:, units:)
        hoteness ={}
        hoteness[:temp] = temp
        hoteness[:units] = units
        file = "hotness.json"
        File.open(file, "w") do |file|
            JSON.dump(hoteness,file)
        end
        return {hotness_setting:hoteness}
    end
end