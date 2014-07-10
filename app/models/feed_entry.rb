class FeedEntry
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :ref, type: BSON::ObjectId
  field :model, type: Symbol

  embedded_in :feed
    
  def create_entry(model)
    self.ref = model.id
    self.model = model.class.to_s.downcase.to_sym
    self    
  end
  
  def model_instance
    self.model.to_s.capitalize.constantize.find(self.ref)
  end
  
end