require 'nokogiri'
require 'httparty'

module PokemonScraper
  BASE_URL = 'https://scrapeme.live/shop/page/'

  def self.retrieve_pokemon_data(pages)
    pokemon_data = []

    pages.each do |page|
      url = "#{BASE_URL}#{page}/"
      response = HTTParty.get(url)
      html = response.body
      doc = Nokogiri::HTML(html)
      products = doc.css('.product')

      products.each_with_index do |product, index|
        id = (page - 1) * 16 + index + 1
        sku = index + 1
        name = product.css('.woocommerce-loop-product__title').text.strip
        price = product.css('.price').text.strip
        image_url = product.css('.wp-post-image').attr('src').value.strip

        pokemon_data << { id: id, name: name, price: price, sku: sku, image_url: image_url }
      end
    end

    pokemon_data
  end
end
