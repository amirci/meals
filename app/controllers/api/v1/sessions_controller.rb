class Api::V1::SessionsController < ActionController::Base 
  acts_as_token_authentication_handler_for User, only: [:destroy], fallback_to_devise: false

  before_filter :authenticate_user!, except: [:create]

  respond_to :json
  
  
  def create
    user = User.find_by_email(params[:user][:email])
    if user.valid_password?(params[:user][:password])
      render json: {login: {token: user.authentication_token}}, status: :ok
    else
      render json: {user: 'someuser@example.com'}, status: :unauthorized
    end
  end

  def destroy
    current_user.authentication_token = nil
    current_user.save!
    render json: {login: {token: current_user.authentication_token}}, status: :ok
  end

  
end
