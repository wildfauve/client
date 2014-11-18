class Customer
  
  attr_accessor :holdings
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  field :number, type: String
  field :permit, type: Boolean
  
  embeds_many :links
  
  after_save :publish_save_event
  
  def self.create_it(params)
    c = self.new
    #c.subscribe(EventHandler.new)
    c.name = params[:name]
    c.number = params[:number]
    c.permit = params[:permit]
    c.save!
    c
  end
  
  def self.get_customer(id: nil)
    cust = self.find(id)
    cust.get_holdings
    cust
  end
  
  def update_it(params)
    self.name = params[:name]
    self.number = params[:number] 
    params[:permit] == 'true' ? self.permit = true : self.permit = false
    self.save!
    self 
  end
    
  def get_holdings
    holding_link = self.links.where(rel: :quota_holding).first
    if holding_link
      @holdings = QuotaHolding.new.find_by_link(link: holding_link )
      maintain_links(self_rel: :quota_holding, links: @holdings["_links"])            
    else
      @holdings = QuotaHolding.new.find(customer_number: self.number)    
      maintain_links(self_rel: :quota_holding, links: @holdings["_links"])      
    end
    save
  end
    
  private
  
  def maintain_links(self_rel: nil, links: nil)
    #self.holding_link = links["self"]["href"]
    links.each {|rel,link| add_or_update_links(self_rel: self_rel, rel: rel, link: link)}
  end
  
  def add_or_update_links(self_rel: nil, rel: nil, link: nil)
    rel == "self" ? rel = self_rel : rel.to_sym
    l = self.links.where(rel: rel).first
    if l.nil?
      self.links << Link.create_link({rel: rel, url: link["href"]})
    else
      return if l.url == link["href"]
      l.update_link({rel: rel, url: link["href"]})
    end
  end
  
  def publish_save_event
    publish(:customer_change_event, self)
    
  end
    
  
end