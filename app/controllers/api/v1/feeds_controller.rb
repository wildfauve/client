class Api::V1::FeedsController < Api::ApplicationController
  
  def index
    @feed = Feed.first
    respond_to do |f|
      f.json
    end
  end
  
end