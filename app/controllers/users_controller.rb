class UsersController < ApplicationController
  def portfolio
    @tracked_stock = current_user.stocks # we used devise hepler methods to check currect user
  end
end
