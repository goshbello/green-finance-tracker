class UserStocksController < ApplicationController

  # to add stock to table from broswer
  
  def create
    #check if user already have the stock. using the check_db method in the stock model
    stock = Stock.check_db(params[:ticker]) 
    # created and save stock to used db if stock doesn't when user click on add to table button
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    #create association => user and stock association
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
    redirect_to portfolio_path
  end

  # a method to destroy or remove stock from user portfolio
  def destroy
    stock = Stock.find(params[:id]) # find the stock to be deleted
    # from the user_stock table, get the id of stock and user. The (.first) will turn output into an object
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    flash[:notice] = "#{stock.ticker} was successfully removed from portfolio"
    redirect_to portfolio_path
  end
end
