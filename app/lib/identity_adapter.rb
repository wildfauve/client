class IdentityAdapter
  
  attr_accessor :user, :access_token, :id_token, :id_token_encoded, :user_proxy
  
  include UrlHelpers
  
  def authorise_url
    q = {}
    q[:response_type] = "code"
    q[:redirect_uri] = url_helpers.authorisation_identities_url host: "localhost:3000"
    q[:state] = "signup"
    q[:client_id] = Client::Application.config.client_id
    "http://localhost:3010/authorise?#{q.to_query}"
  end
  
  def logout_url(user_proxy: nil)
    q = {post_logout_redirect_uri: url_helpers.root_url(host: "localhost:3000")}
    q[:id_token_hint] = user_proxy.id_token_encoded
    "http://localhost:3010/logout?#{q.to_query}"
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
    validate_id_token()
    get_user()
    @user_proxy = UserProxy.find_or_create(auth: self, id_token_provided: self.id_token_provided?)
    self
  end

  def get_user
    conn = Faraday.new(url: 'http://localhost:3010/userinfo')    
    conn.params = {access_code: @access_token["access_code"]} 
    #conn.basic_auth Client::Application.config.client_id, Client::Application.config.client_secret    
    conn.authorization :Bearer, @access_token["access_code"]
    resp = conn.get
    raise if resp.status >= 300
    @user = JSON.parse(resp.body)
    self
  end
  
  def validate_id_token
    begin
      @id_token_encoded = @access_token["id_token"]      
      @id_token = JWT.decode(@id_token_encoded, Client::Application.config.id_token_secret).inject(&:merge)
    rescue JWT::DecodeError => e
      raise
    end
  end
  
  def id_token_provided?
    @id_token ? true : false
  end
  
end