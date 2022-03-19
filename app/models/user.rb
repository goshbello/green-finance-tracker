class User < ApplicationRecord

  # many to many association
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  # many-to-many association / self referential association for friends/friendship and users
  has_many :friendships
  has_many :friends, through: :friendships

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


  # Search for friends
  # *****************

  # Search with the user entry.
  def self.search(param)
    param.strip! # remove any space

    # return result of search. We use "uniq" to return uniq entry, full_name, last_name, etc
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq 
    return nil unless to_send_back
    to_send_back
  end

  # check user entry matches field_name [database coloumn]
  def self.first_name_matches(param)
    matches('first_name', param)
  end

   # check user entry matches field_name [database coloumn]
  def self.last_name_matches(param)
    matches('last_name', param)
  end

   # check user entry matches field_name [database coloumn]
  def self.email_matches(param)
    matches('email', param)
  end


  # class method to check user database column field [email, first_name, last_name] as (field_name) with user entery (params) to list friends
  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%") # '%' is a wild card serves as a placeholder
  end



  # method to reject the user being added to the list of other user search
  def except_current_user(users)
    users.reject {|user| user.id == self.id }
  end

  # method to show friends who appears on the friend link when we run a search
  def not_friends_with?(id_of_friend)
    !self.friends.where(id: id_of_friend).exists? # we checking for false, if id is not id of friends
  end

end
