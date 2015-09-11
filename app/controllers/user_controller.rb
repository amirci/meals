class UserController < ApplicationController
  before_action :set_user, only: [:update]
  before_action :authenticate_user!
  
  def update
    if @user.update(user_params)
      render :show, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  
  def set_user
    @user = User.find params[:id]
  end
  
  def user_params
    params.require(:config).permit(:calories)
  end
  
end
