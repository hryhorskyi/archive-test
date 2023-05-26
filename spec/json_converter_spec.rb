require 'json'
require_relative '../lib/json_converter'

RSpec.describe JsonConverter do
  describe '.convert_to_json' do
    it 'converts data to JSON format' do
      data = { id: 1, name: 'John', age: 25 }
      expected_json = <<~JSON
        {
          "id": 1,
          "name": "John",
          "age": 25
        }
      JSON

      json_data = JsonConverter.convert_to_json(data)
      expect(json_data).to eq(expected_json.strip)
    end

    it 'returns an empty JSON object for empty data' do
      data = {}
      expected_json = '{}'

      json_data = JsonConverter.convert_to_json(data)
      expect(JSON.parse(json_data)).to eq(JSON.parse(expected_json))
    end
      

    it 'handles arrays and nested objects' do
      data = {
        name: 'Alice',
        age: 30,
        hobbies: ['reading', 'painting'],
        address: {
          street: '123 Main St',
          city: 'New York',
          country: 'USA'
        }
      }
      expected_json = <<~JSON
        {
          "name": "Alice",
          "age": 30,
          "hobbies": [
            "reading",
            "painting"
          ],
          "address": {
            "street": "123 Main St",
            "city": "New York",
            "country": "USA"
          }
        }
      JSON

      json_data = JsonConverter.convert_to_json(data)
      expect(json_data).to eq(expected_json.strip)
    end
  end
end
