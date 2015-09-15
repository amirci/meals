class Api::V1::SessionsController < ActionController::Base #ApplicationController
  authorize_resource :except => [:create, :destroy]
  before_filter :authenticate_user!, except: [:create]
  respond_to :json
  
  # acts_as_token_authentication_handler_for User
  
  def create
    user = User.find_by_email(params[:user][:email])
    if user.valid_password?(params[:user][:password])
      render json: {login: {token: user.authentication_token}}, status: :ok
    else
      render json: {user: 'someuser@example.com'}, status: :unauthorized
    end
  end

  def destroy
    puts "---- regnerate token for current user #{current_user}"
  end

  
end
