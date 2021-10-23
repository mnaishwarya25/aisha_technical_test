#README

### Building a GraphQL API Using Ruby on Rails for a company called "CLIMATE CONTROL".

### @author Aishwarya Marghatta Nandeesh <mnaishwarya1@gmail.com, 9376262231>

#####This README file includes the steps that are necessary to get the application up and running.

#####Framework and Version:
Ruby version used: 2.7.2
Rails version used: 6.0.4.1
Tools Used: Command Line Interface (CLI), Visual Studio Code, Git, Chrome Web Browser, GraphQL.

### Steps followed to create the server:

Note: `timeZone` is identified as `timezone` in the queries.

### Creating rails new api app

 `rails new climate_control --api --skip-test`

### Add required gems/packages

I located `GemFile` in the root folder of the project

```
gem 'graphiql-rails'
gem 'graphql'

```

### Executed below command:

`$ bundle install` to install the new added gems to the project


### I then generated the graphql files using: 

`$ rails generate graphql:install`

this command added the new directory : `graphql` with several files to the project

Then,

### I edited the rails route, to match graphql development mode in rails! I made the file to look like this 

 ```ruby
Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#Execute"
  end
  post "/graphql", to: "graphql#execute"
end

 ```
 which means request for graphql would be to `/graphiql` 

### I then added these below links

 ```
// = link graphiql/rails/application.css
// = link graphiql/rails/application.js

```

setting to `/app/assest/config/manifest.js` file.

### After doing this, I restarted the server & it started running successfully!

The url to visit the graphQL in local server is ``http://127.0.0.1:3000/graphiql`` and below are the default commands for testing the graphQL, which schema to execute the required queries was not present. 

The default query existed :
```graphql
query{
  testField
}

```

For the above query, it returned the following JSON Structure

```json
{
  "data": {
    "testField": "Hello World!"
  }
}
```
 I deleted the above default query for adding the required test query.

## Creating types 

I added the 'types' and from running `rails generate`, I saw that rails generated whole lot of things. Using generators, helped me to save time for writing the boiler plate code. 
First thing was `objects` which I used this, to generate the different 'objects types'.

like :

`$ rails g graphql:object Coordinates` which then generated  `coordinated_type.rb` file with base for my coordinated type, I did this for all the types in the instructions.

## rails graphql type

In rails the `!` for required in graphql that represents as `null: false`

so the `Coordinates` type in my case looked like this

```graphql
module Types
  class CoordinatesType < Types::BaseObject
    field :lat, Float, null: false
    field :lon, Float, null: false
  end
end
```
I followed similar procedure for creating all other types.

I also ended up adding 'enums' for the hotness settings. I generated the file using the enum generator again and updated the code to look like this

```ruby
module Types
  class TempUnitsType < Types::BaseEnum
    value "FAHRENHEIT"
    value "CELSIUS"
    value "KELVIN"
  end
end
```

This allows me to select any of the the values in 
the `updateHotnessSettings` mutation, which I also created by creating a file `update_hotness_settings.rb` in mutation folder

the `updateHotnessSettings` mutation the file to look like This

```ruby
class Mutations::UpdateHotnessSettings < Mutations::BaseMutation
    argument :temp, Float, required: true
    argument :units, Types::TempUnitsType, required: true

    field :hotness_setting, Types::HotnessSettingType, null: true
    
    def resolve(temp:, units:)
        hoteness ={}
        hoteness[:temp] = temp
        hoteness[:units] = units
        return {hotness_setting:hoteness}
    end
end

```
 which is basic way of creating a mutation


# Queries, Mutations and API


### settings hotness

We need to run mutation `updatehotnesssettings` before running the filter queries, because the values are stored in the file, `hotness.json` which may cause server to fail if it does not exist.

### mutation example

```graphql
mutation{
  hotnessSetting(input:{units:KELVIN, temp:249}){
    hotnessSetting{
      units
      temp
    }
  }
}
```

The above query will then save units = KELVIN and temp = `249.0` as hot lowest limit, which is used to filter the 'hot' and 'not hot' cities weather.


### queries 

Here, I configured the settings on endpoints for the queries and mutation.

For the `hotOrNotCitiesWeather` query, I passed the 'name' as argument, then used the 'name' to select all cities with the name, then I query the `API` for the data, for the city name via url:
`http://api.openweathermap.org/data/2.5/weather?q=" + name + "&appid="+api_key`

where `name` and `api_key` are the respective variables.

This would return data wherein `wind` was always included but `rain` and `snow` was quite a times missing so I had to check for the conditions!

For this, I looped over cities with the names and updated the respective values and then retuned them all as array.

Testing the queries and mutations worked well and Successfully accomplished with test cases. Here is an example query below:

example query
```graphql
query{
  hotOrNotCitiesWeather(name: "Portland") {
    city {
      coordinates {
        lat
        lon
      }
      country
      id
      name
      state
      sunrise
      sunset
      timezone
    }
    weather {
      cloudPer
      feelsLike
      groundLevel
      hot
      humidity
      pressure
      rain {
        volOneHour
        volThreeHours
      }
      seaLevel
      snow {
        volOneHour
        volThreeHours
      }
      temp
      tempMax
      tempMin
      visibility
      weatherDescription {
        description
        iconCode
        id
        main
      }
      rain{
        volOneHour
      }
      wind {
        speed
        degrees
        gustSpeed
      }
      
    }
  }
}

```

OUTPUT:

```json
{
  "data": {
    "hotOrNotCitiesWeather": [
      {
        "city": {
          "coordinates": {
            "lat": -38.333328,
            "lon": 141.600006
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": -33.366669,
            "lon": 150
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": 18.133329,
            "lon": -76.533333
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": 16.3242,
            "lon": -61.323528
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": 36.581711,
            "lon": -86.51638
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "TN",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": 27.877251,
            "lon": -97.323883
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "TX",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": 41.57288,
            "lon": -72.640648
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "CT",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": 40.43449,
            "lon": -84.977753
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "IN",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": 43.661469,
            "lon": -70.255333
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "ME",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": 42.869202,
            "lon": -84.903053
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "MI",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      },
      {
        "city": {
          "coordinates": {
            "lat": 45.523449,
            "lon": -122.676208
          },
          "country": "US",
          "id": 5746545,
          "name": "Portland",
          "state": "OR",
          "sunrise": "1634913404",
          "sunset": "1634951590",
          "timezone": "-25200"
        },
        "weather": {
          "cloudPer": 90,
          "feelsLike": null,
          "groundLevel": null,
          "hot": true,
          "humidity": 93,
          "pressure": 1009,
          "rain": null,
          "seaLevel": null,
          "snow": null,
          "temp": 283.64,
          "tempMax": 285.15,
          "tempMin": 282.25,
          "visibility": 10000,
          "weatherDescription": {
            "description": "overcast clouds",
            "iconCode": "04d",
            "id": 804,
            "main": "Clouds"
          },
          "wind": {
            "speed": 0.45,
            "degrees": 0,
            "gustSpeed": 1.34
          }
        }
      }
    ]
  }
}
```
Adding additional parameters for the query `hot:true` or `hot:false` will then trigger
the correct filter for the cities. 

```graphql
query{
  hotOrNotCitiesWeather(name: "Portland", hot: false) {
    weather {
      feelsLike
      hot
      temp
    }
  }
}
```
Also, adding `feelsLike:true` or `feelsLike:false` will then trigger
the correct filter for the cities

```graphql
query{
  hotOrNotCitiesWeather(name: "Portland", feelsLike: true) {
    weather {
      feelsLike
      hot
      temp
    }
  }
}
```