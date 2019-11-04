class UsersController < ApplicationController
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      log_in(@user) # go to sessions_helper en set a new session
      flash[:success] = "Welcome to the Sample App! " + @user.name
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
