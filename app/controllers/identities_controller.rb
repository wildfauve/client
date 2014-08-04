class IdentitiesController < ApplicationController
  
  def sign_up
    raise
  end
  
  def login
    # Send the Login to the ID Service via a OAuth Redirect
    auth_service = IdentityAdapter.new.authorise_url
    redirect_to auth_service
  end
  
  def authorisation
    # Get an access token for the logged_in user from the ID Service using an OAuth /token call
    # Now we need to create an internal "user" by getting the /me
    auth = IdentityAdapter.new.get_access(params)
    #user_proxy = UserProxy.find_or_create(auth: auth, id_token_provided: auth.id_token_provided?)
    session[:user_proxy] = {proxy_id: auth.user_proxy.id.to_s, expires: 10.minutes.from_now}
    redirect_to customers_path
  end
  
  def logout
    auth_logout_service = IdentityAdapter.new.logout_url(user_proxy: @current_user_proxy)
    session[:user_proxy] = nil
    redirect_to auth_logout_service
  end
  
end