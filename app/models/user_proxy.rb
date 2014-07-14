class UserProxy
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  field :email, type: String
  field :access_token, type: Hash
  field :id_token_encoded, type: String
  
  def self.find_or_create(auth: nil, id_token_provided: nil)
    id_token_provided ? up = find_by_user_name(name: auth.id_token["preferrer_username"]) : up = find_by_user_name(name: auth.user["user_name"])
    if up
      up.add_attrs(auth: auth, id_token_provided: id_token_provided)
    else
      up = self.new.add_attrs(auth: auth, id_token_provided: id_token_provided)
    end
    up
  end
    
  def self.find_by_user_name(name: nil, id_token_provided: nil)
    self.where(name: name).first
  end
  
  def add_attrs(auth: nil, id_token_provided: nil)
    if id_token_provided
      name = "preferred_username"
      email = "email_verified"
      key = :id_token
    else
      name = "user_name"
      email = "user_email"
      key = :user
    end
    self.name = auth.send(key)[name]
    self.email = auth.send(key)[email]
    self.access_token = auth.access_token
    self.id_token_encoded = auth.id_token_encoded
    save
    self
  end
    
  
end