class Link
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :rel, type: Symbol
  field :url, type: String
  
  
  embedded_in :customer
  
  def self.create_link(params)
    l = self.new(params)
    l
  end
  
  def update_link(params)
    self.attributes = params
  end
  
end
