class UserProxy
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  field :email, type: String
  field :access_token, type: Hash
  
  def self.find_or_create(auth: nil)
    up = self.where(name: auth.user["user_name"]).first
    if up
      up.add_attrs(auth: auth)
    else
      up = self.new.add_attrs(auth: auth)
    end
    up
  end
  
  def add_attrs(auth: nil)
    self.name = auth.user["user_name"]
    self.email = auth.user["user_email"]
    self.access_token = auth.access_token
    save
    self
  end
    
  
end