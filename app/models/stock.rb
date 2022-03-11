class Stock < ApplicationRecord

  # we create a method to get the stock price

  def self.new_lookup(ticker_symbol) # "self." + method name make the method class method
    client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
                                  secret_token: Rails.application.credentials.iex_client[:secret_token_key],
                                  endpoint: 'https://sandbox.iexapis.com/v1')

    #return price
    client.price(ticker_symbol) 
  end
end
