class EventHandler
  
  CUST_QUEUE = "cust_queue"
  
  def customer_change_event(customer)
    $redis.lpush CUST_QUEUE, customer.to_json
    Feed.add_to_feed(customer)
  end
end