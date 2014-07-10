class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user_proxy
  
  before_filter :current_user_proxy
  
  private
  
  def current_user_proxy
    @current_user_proxy ||= UserProxy.find(session[:user_proxy]["proxy_id"]) if session[:user_proxy]    
  end
  
  
end
