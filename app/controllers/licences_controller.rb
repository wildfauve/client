class LicencesController < ApplicationController
  
  def index
    redirect_to "http://localhost:3002?client_id=1234"
  end
  
end