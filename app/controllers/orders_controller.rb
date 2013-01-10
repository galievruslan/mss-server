class OrdersController < ApplicationController
  DISHES = [
    { :rating =>2, :category => "singaporean", :dish_name => "Fish Head Curry", :where_to_buy => "Little India" },
    { :rating =>0, :category => "singaporean", :dish_name => "Pig Organ Soup", :where_to_buy => "Food Court" },
    { :rating =>8, :category => "indian", :dish_name => "Chicken Biryani", :where_to_buy => "Al Ameen's" },
    { :rating =>9, :category => "german", :dish_name => "Pork Knuckle", :where_to_buy => "Stammtisch Restaurant" },
    { :rating =>10, :category => "indian", :dish_name => "Butter Chicken", :where_to_buy => "Jaggi's Northern Indian Cuisine" },
    { :rating =>10, :category => "indian", :dish_name => "Chicken Tikka", :where_to_buy => "Jaggi's Northern Indian Cuisine" },
    { :rating =>7, :category => "singaporean", :dish_name => "Mutton Murtabak", :where_to_buy => "Zam Zam Restaurant" },
    { :rating =>8, :category => "singaporean", :dish_name => "Chicken Murtabak", :where_to_buy => "Ah Mei Kaya Toast" },
    { :rating =>9, :category => "western", :dish_name => "Beef Cheek", :where_to_buy => "Ember Restaurant" },
    { :rating =>8, :category => "western", :dish_name => "Cowboy Burger", :where_to_buy => "Brewerkz" },
    { :rating =>8, :category => "mexican", :dish_name => "Pork Enchilada", :where_to_buy => "Iguana Cafe" }
  ]
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
  
  def generate_xml
    hijack_response(generate_builder)
  end
  
  def hijack_response(out_data)
    send_data(out_data, :type => "text/xml", :filename => "sample.xml")
  end
  
  def generate_builder
    doc = Builder::XmlMarkup.new( :target => out_string = "", :indent => 2 )
    doc.Food {
      DISHES.each{ |element_data|
        doc.Dish( "rating" => element_data[:rating], "category" => element_data[:category] ){
          doc.DishName( element_data[:dish_name] )
          doc.WhereToBuy( element_data[:where_to_buy] )
        }
      }
    }
    return out_string
  end
end
