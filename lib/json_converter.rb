require 'json'

module JsonConverter
  def self.convert_to_json(data)
    JSON.pretty_generate(data)
  end
end
