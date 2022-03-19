class UsersController < ApplicationController
  def portfolio
    @user = current_user
    @tracked_stock = current_user.stocks # we used devise hepler methods to check currect user
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends) # remove current user from the return list
      if @friends
        respond_to do |format|
          format.js { render partial: 'users/friend_result'}
        end
      else
        respond_to do |format|
          flash.now[:arlert] = "Counldn't find user"
          format.js { render partial: 'users/friend_result'}
        end
      end
    else
      respond_to do |format|
        flash.now[:arlert] = "Please enter a friend name or email to search"
        format.js { render partial: 'users/friend_result'}
      end
    end
  end


  # show / display user profile
  def show
    @user = User.find(params[:id])
    @tracked_stock = @user.stocks  # we used this display the tracked stock for each user
  end

end