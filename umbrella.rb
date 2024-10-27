require "dotenv/load"
require "http"
require "json"

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
gmaps_key = ENV.fetch("GMAPS_KEY")

# pp pirate_weather_key
# pp gmaps_key

puts "Where are you?"
user_location = gets.chomp
# pp user_location

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + gmaps_key
# pp gmaps_url


raw_gmaps_data = HTTP.get(gmaps_url)
# puts raw_gmaps_data.to_s

parsed_gmaps_data = JSON.parse(raw_gmaps_data)
# pp parsed_gmaps_data.keys

coordinates = parsed_gmaps_data.fetch("results").at(0).fetch("geometry").fetch("location")
# pp coordinates.fetch("lat")
# pp coordinates.fetch("lng")

latitude = coordinates.fetch("lat")
longitude = coordinates.fetch("lat")

puts "Your coordinates are #{latitude} and #{longitude}."
puts "Checking your weather..."

weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"
# pp weather_url

raw_weather_data = HTTP.get(weather_url)
# pp raw_weather_data.to_s

weather_data = JSON.parse(raw_weather_data)
# pp weather_data

temperature = weather_data.fetch("currently").fetch("temperature")
puts "It is currently #{temperature} Fahrenheit"

next_hour_data = weather_data.fetch("hourly").fetch("summary")
puts "Next hour: #{next_hour_data}"

hourly_data = weather_data.fetch("hourly").fetch("data")
# puts hourly_data

next_twelve_hours = hourly_data[1..12]
threshold = 0.1
raining = false

# pp next_twelve_hours

next_twelve_hours.each do |hour|
  precip_prob = hour.fetch("precipProbability")
    if precip_prob > 0.1
      raining = true
    end
end

if raining == true
  puts "You might want an umbrella!"
else
  puts "No umbrella needed!"
end
