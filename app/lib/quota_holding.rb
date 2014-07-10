class QuotaHolding
  #include Her::Model
  #use_api TXN_API  
  #parse_root_in_json true, format: :active_model_serializers
  #collection_path "transaction_accounts/quota_holdings"
  RES = "http://localhost:3001/api/v1/transaction_accounts/quota_holdings" 
  HOST = "http://localhost:3001"
  SERVICE = "http://localhost:3001/api/v1/transaction_accounts"  
  
  def self.find_all
    h = self.all
  end
  
  def initialize
    @conn = Faraday.new
  end
  
  def find(customer_number: nil)
    #resp = RestClient.get RES, {params: { client_number: customer_number} }
    resp = @conn.get(RES, client_number: customer_number )
    if resp.status >= 400
      raise
    else
      JSON.parse(resp.body)
    end
  end
  
  def find_by_link(link: nil)
    resp = @conn.get("#{HOST}#{link.url}")
    if resp.status >= 400
      raise
    else
      JSON.parse(resp.body)
    end    
  end  
end