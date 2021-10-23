# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_21_210656) do

  create_table "cities", force: :cascade do |t|
    t.string "country"
    t.string "name"
    t.datetime "sunrise"
    t.datetime "sunset"
    t.integer "timezone"
    t.integer "coordinates_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coordinates_id"], name: "index_cities_on_coordinates_id"
  end

  create_table "city_weather_one_days", force: :cascade do |t|
    t.integer "city_id", null: false
    t.integer "one_day_weather_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_city_weather_one_days_on_city_id"
    t.index ["one_day_weather_id"], name: "index_city_weather_one_days_on_one_day_weather_id"
  end

  create_table "coordinates", force: :cascade do |t|
    t.float "lat"
    t.float "lon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "one_day_weathers", force: :cascade do |t|
    t.integer "cloudPer"
    t.float "feelsLike"
    t.integer "groundLevel"
    t.boolean "hot"
    t.integer "humidity"
    t.integer "pressure"
    t.integer "seaLevel"
    t.float "temp"
    t.float "tempMax"
    t.float "tempMin"
    t.integer "visibility"
    t.integer "WeatherDescription_id", null: false
    t.integer "wind_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["WeatherDescription_id"], name: "index_one_day_weathers_on_WeatherDescription_id"
    t.index ["wind_id"], name: "index_one_day_weathers_on_wind_id"
  end

  create_table "rains", force: :cascade do |t|
    t.integer "volOneHour"
    t.integer "volThreeHours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "snows", force: :cascade do |t|
    t.integer "volOneHour"
    t.integer "volThreeHours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "weather_descriptions", force: :cascade do |t|
    t.string "description"
    t.string "iconCode"
    t.string "main"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "winds", force: :cascade do |t|
    t.integer "degress"
    t.integer "gustSpeed"
    t.float "speed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "cities", "coordinates", column: "coordinates_id"
  add_foreign_key "city_weather_one_days", "cities"
  add_foreign_key "city_weather_one_days", "one_day_weathers"
  add_foreign_key "one_day_weathers", "WeatherDescriptions"
  add_foreign_key "one_day_weathers", "winds"
end
