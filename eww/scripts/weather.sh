#!/bin/bash

# get hourly weather from the NWS
weather_url='https://api.weather.gov/gridpoints/BOU/72,53/forecast/hourly'

# only get the next 12 hours of data
jq_cmd='.properties.periods | map(select( .number <= 13 ))
        | map( . + { 
            hour: .startTime | split("-") | .[0:3] | join("-")
                  | strptime("%Y-%m-%dT%H:%M:%S") | strftime("%-I %P") 
          }
        )'

curl "${weather_url}" 2>/dev/null | jq -rc "${jq_cmd}"
