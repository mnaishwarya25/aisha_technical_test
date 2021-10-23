require "uri"
require "net/http"

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField


    field :hotness_setting, Types::HotnessSettingType, null: true

    def hotness_setting
      nil
    end

    field :hot_or_not_cities_weather, [Types::CityWeatherOneDayType], null: true do
      argument :name, String, required:true
      argument :hot, Boolean, required:false
      argument :feels_like, Boolean, required:false
    end

    def hot_or_not_cities_weather(args)
      name = args[:name]
      file = File.read('city.json')
      temp_file = File.read('hotness.json')
      data_hash = JSON.parse(file)
      temp_hotness = JSON.parse(temp_file)

      api_key = "b36cf3463aab9f7d5d71d2b0956292d4"
      url = "http://api.openweathermap.org/data/2.5/weather?q=" + name + "&appid="+api_key

      cities_weather = []
      url = URI(url)

      http = Net::HTTP.new(url.host, url.port);
      request = Net::HTTP::Get.new(url)



      response = http.request(request)
      data =  JSON.parse(response.body)
      cities =  data_hash.select {|city| city['name']==name}
      cities.each do |city|
        hotness = temp_hotness['temp']
        weather = data['main']
        weather[:cloud_per] = data['clouds']['all']

        weather_description = data['weather'][0]
        weather_description['icon_code'] = weather_description['icon']
        weather[:weather_description] = weather_description

        wind = data['wind']
        wind['degrees'] = wind['deg']
        wind['gust_speed'] = wind['gust']
        weather[:wind] = wind

        if(data['rain'])
          rain = data['rain']
          rain['vol_one_hour'] = data['rain']['1h']
          rain['vol_three_hours'] = data['rain']['3h']

        else
          rain = nil
        end
        weather[:rain] = rain
        weather[:visibility] = data['visibility']

        weather[:hot] = data['main']['temp'] > hotness
        weather[:feels_like] = data['main']['feels_like'] > hotness
        city['country'] = data['sys']['country']
        city['sunrise'] = data['sys']['sunrise']
        city['sunset'] = data['sys']['sunset']
        city['timezone'] = data['timezone']
        city['id'] = data['id']
        city['coordinates'] = city['coord']
        retData = {
          }
        retData[:weather] = weather
        retData[:city] = city
        if (args[:hot]!=nil or args[:feels_like]!=nil)
          if (args[:hot]==false)
            puts weather[:hot] == args[:hot]
            if (weather[:hot] == args[:hot])
              cities_weather.append(retData)
            end
          end
          if (args[:hot] == true)

              if (weather[:hot] == args[:hot])
                cities_weather.append(retData)
              end
          end

          if (args[:feels_like]==false)
              if (weather[:feels_like] == args[:feels_like])
                cities_weather.append(retData)
              end
          end
          if (args[:feels_like]==true)
            if (weather[:feels_like] == args[:feels_like])
              cities_weather.append(retData)
            end
          end
        else
          cities_weather.append(retData)
        end
    end
    puts "hee"
    cities_weather
  end

end
end
