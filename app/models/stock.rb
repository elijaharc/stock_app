class Stock < ApplicationRecord
    has_many :broker_stocks
    has_many :brokers, through: :broker_stocks
    has_many :buyer_stocks
    has_many :buyers, through: :buyer_stocks

    # Did not include :price because it changes
    validates :name, :ticker, presence: true

    def self.new_search(ticker_symbol)
      client = IEX::Api::Client.new(
        publishable_token: 'pk_bacfbee65b8d4f7284e9ef165b0f801f',
        secret_token: 'sk_3712c31a1ee241cf99ec4b70435ec1a0',
        endpoint: 'https://cloud.iexapis.com/v1/'  
        # publishable_token: ENV["IEX_SANDBOX_PUBLISHABLE_KEY"],
        # secret_token: ENV["IEX_SANDBOX_SECRET_KEY"],
        # endpoint: 'https://sandbox.iexapis.com/v1'  
        )
        logo = client.logo(ticker_symbol)
      begin
          #ticker is upcased because if not, it doesn't recognize that I've already added the same stock
        new(ticker: ticker_symbol.upcase, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol), logo: logo.url)
      rescue => exception
        return nil
      end
    end

    def self.check_db(ticker_symbol, broker_id)
      find_by(ticker: ticker_symbol, added_by: broker_id)
    end
    
    # Doesn't work in Sandbox ENV
    # def self.stock_logo(ticker_symbol)
    #     client = IEX::Api::Client.new(
    #         publishable_token: ENV["IEX_PUBLISHABLE_KEY"],
    #         secret_token: ENV["IEX_SECRET_KEY"],
    #         # publishable_token: Rails.application.credentials.iex_client[:publishable_access_key],
    #         # secret_token: Rails.application.credentials.iex_client[:secret_access_key],
    #         endpoint: 'https://cloud.iexapis.com/v1'
    #       )
    #     logo = client.logo(ticker_symbol)
    #     logo.url
    # end

    def self.stock_list
      client = IEX::Api::Client.new(
        publishable_token: ENV["IEX_SANDBOX_PUBLISHABLE_KEY"],
        secret_token: ENV["IEX_SANDBOX_SECRET_KEY"],
        endpoint: 'https://sandbox.iexapis.com/v1'
        )
      client.stock_market_list(:mostactive)
    end
end