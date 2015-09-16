class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  acts_as_token_authentication_handler_for User
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    # render what you want here
    render :json => @error_object.to_json, :status => :not_found
  end

  rescue_from StandardError do |exception|
    # render what you want here
    render :json => @error_object.to_json, :status => :unprocessable_entity
  end


  def access_denied(exception)
    redirect_to new_user_session_path, :alert => exception.message
  end
  
  def authenticate_admin_user!
    authenticate_user!
    puts ">>> is the user admin? #{can? :read, ActiveAdmin::Page, :name => "Dashboard"}"
    unless can? :read, ActiveAdmin::Page, :name => "Dashboard"
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end
    
end
