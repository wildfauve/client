class CustomersController < ApplicationController

  def index 
    @customers = Customer.all
    session[:client_id] = "1234"
  end
  
  def new
    @customer = Customer.new
  end
  
  def show
    raise
    @customer = Customer.get_customer(id: params[:id])
  end
  
  def create
    @customer = Customer.create_it(params[:customer])
    @customer.subscribe(EventHandler.new)    
    respond_to do |format|
      if @customer.valid?
        format.html { redirect_to customers_path }
      else
        format.html { render action: "new" }
      end
    end      
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.subscribe(EventHandler.new)
    @customer.update_it(params[:customer])
    respond_to do |format|
      if @customer.valid?
        format.html { redirect_to customers_path }
      else
        format.html { render action: "new" }
      end
    end      
  end
  


end