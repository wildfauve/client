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
    IdentityAdapter.new.get_access(params)
    # Now we need to create an internal "user" by getting the /me
    
  end
  
end