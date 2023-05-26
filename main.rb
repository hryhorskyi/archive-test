require_relative 'lib/pokemon_scraper'
require_relative 'lib/json_converter'

pages_range = (1..48).to_a
pokemon_data_array = PokemonScraper.retrieve_pokemon_data(pages_range)

json_data = JsonConverter.convert_to_json(pokemon_data_array)

File.open('result.json', 'w') do |file|
  file.puts(json_data)
end

puts "JSON data has been written to result.json"
