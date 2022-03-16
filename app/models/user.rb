class User < ApplicationRecord

  # many to many association
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # check if user is already tracking stock
  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol) # first check user db using the check_db method
    return false unless stock
    stocks.where(id: stock.id).exists? # check if stock is in user/stock association
  end

  # check if user stock is under 10
  def under_stock_limit?
    stocks.count < 10
  end

  # allow user to track stock if limit is under 10 and stock is not already been tracked
  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  # method to return full_name of user
  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name # display first, last or full name if available
    "Anonymous"  # else display Anonymous
  end
end
