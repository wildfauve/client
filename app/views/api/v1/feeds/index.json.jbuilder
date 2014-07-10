json.kind "feed"
json.last_updated @feed.last_updated
json.entries @feed.feed_entries do |ent|
  model = ent.model_instance
  json.kind "customer"
  json.name model.name
  json.number model.number
  json.permit model.permit
  json.updated_at model.updated_at
  json._links do
    json.self do 
      json.href api_v1_customer_path(model)
    end
  end
end