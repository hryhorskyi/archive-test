require 'nokogiri'
require 'httparty'
require_relative '../lib/pokemon_scraper'

RSpec.describe PokemonScraper do
  describe '.retrieve_pokemon_data' do
    let(:pages) { [1, 2] }
    let(:base_url) { 'https://scrapeme.live/shop/page/' }
    let(:response_body) { '<html>...</html>' }
    let(:parsed_html) { double('parsed_html') }
    let(:product_html) { '<div class="product">...</div>' }
    let(:parsed_product_html) { double('parsed_product_html') }
    let(:product_data) do
      {
        id: 1,
        name: 'Pikachu',
        price: '$10',
        sku: 1,
        image_url: 'https://example.com/pikachu.jpg'
      }
    end

    before do
      allow(HTTParty).to receive(:get).and_return(double(body: response_body))
      allow(Nokogiri::HTML).to receive(:parse).and_return(parsed_html)
      allow(parsed_html).to receive(:css).with('.product').and_return([parsed_product_html])
      allow(parsed_product_html).to receive(:css).with('.woocommerce-loop-product__title').and_return(double(text: 'Pikachu'))
      allow(parsed_product_html).to receive(:css).with('.price').and_return(double(text: '$10'))
      allow(parsed_product_html).to receive(:css).with('.wp-post-image').and_return(double(attr: double(value: 'https://example.com/pikachu.jpg')))
    end

    it 'returns an array of Pokémon data' do
      allow(HTTParty).to receive(:get).with("#{base_url}1/").and_return(double(body: response_body))
      allow(HTTParty).to receive(:get).with("#{base_url}2/").and_return(double(body: response_body))
      allow(Nokogiri::HTML).to receive(:parse).with(response_body).twice
      allow(parsed_product_html).to receive(:css).with('.woocommerce-loop-product__title').and_return([double(text: 'Pikachu')])
      allow(parsed_product_html).to receive(:css).with('.price').and_return([double(text: '$10')])
      allow(parsed_product_html).to receive(:css).with('.wp-post-image').and_return([double(attr: double(value: 'https://example.com/pikachu.jpg'))])

      pokemon_data = PokemonScraper.retrieve_pokemon_data(pages)

      expect(pokemon_data).to be_an(Array)
    end
  end
end