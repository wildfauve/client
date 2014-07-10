TXN_API = Her::API.new

TXN_API.setup url: "http://localhost:3001/api/v1" do |t|
  # Request
  t.use Faraday::Request::UrlEncoded

  # Response
  t.use Her::Middleware::DefaultParseJSON

  # Adapter
  t.use Faraday::Adapter::NetHttp
end