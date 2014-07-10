class IdentityAdapter
  
  attr_accessor :user, :access_token
  
  include UrlHelpers
  
  def authorise_url
    q = {}
    q[:response_type] = "code"
    q[:redirect_uri] = url_helpers.authorisation_identities_url host: "localhost:3000"
    q[:state] = "signup"
    q[:client_id] = Client::Application.config.client_id
    "http://localhost:3010/authorise?#{q.to_query}"
  end
  
  #POST /token HTTP/1.1
  #   Host: server.example.com
  #   Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
  #   Content-Type: application/x-www-form-urlencoded
  #
  #   grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA
  #   &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb
  
  def get_access(params)
    form = { grant_type: "authorization",
      code: params[:code],
      redirect_uri: url_helpers.authorisation_identities_url(host: "localhost:3000")
    }
    Faraday.new do |c|
      c.use Faraday::Request::BasicAuthentication
    end
    conn = Faraday.new(url: 'http://localhost:3010/token')
    conn.params = form
    conn.basic_auth Client::Application.config.client_id, Client::Application.config.client_secret
    resp = conn.post
    raise if resp.status >= 300
    @access_token = JSON.parse(resp.body)
    get_user()
  end

  def get_user
    conn = Faraday.new(url: 'http://localhost:3010/me')    
    conn.params = {access_code: @access_token["access_code"]} 
    conn.basic_auth Client::Application.config.client_id, Client::Application.config.client_secret    
    resp = conn.get
    raise if resp.status >= 300
    @user = JSON.parse(resp.body)
    self
  end
  
end