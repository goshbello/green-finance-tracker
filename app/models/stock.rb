class Stock < ApplicationRecord

  #many to many association
  has_many :user_stocks
  has_many :users, through: :user_stocks

  #validation
  validates :name, :ticker, presence: true

  # we create a method to get the stock price
  def self.new_lookup(ticker_symbol) # "self." + method name make the method class method
    client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
                                  secret_token: Rails.application.credentials.iex_client[:secret_token_key],
                                  endpoint: 'https://sandbox.iexapis.com/v1')

    # return price
    # client.price(ticker_symbol) 
    # create new object since we are with the class, we can use "new()" or "Stock.new()"
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol) )
    rescue => execption
      return nil
    end
  end
end
