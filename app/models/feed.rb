class Feed
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :last_updated, type: Time
  
  embeds_many :feed_entries
  

  def self.add_to_feed(model)
    feed = Feed.last
    feed = Feed.new if !feed
    feed.last_updated = Time.now
    feed.add_entry(model)
    feed
  end
  
  def add_entry(model)
    ent = self.feed_entries.where(ref: model.id).first
    if !ent
      ent = FeedEntry.new.create_entry(model)
      self.feed_entries << ent
    end
    self.last_updated = Time.now
    self.save
    self
  end
  
end