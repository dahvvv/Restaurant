require 'bundler'
Bundler.require
require './connection'

ROOT_PATH = Dir.pwd
Dir[ROOT_PATH + "/models/*.rb"].each { |file| require file }

# conn = PG::Connection.open()
# conn.exec('DROP DATABASE IF EXISTS restaurant_db;')
# conn.exec('CREATE DATABASE restaurant_db;')
# conn.close

# conn = PG::Connection.open(dbname: 'restaurant_db')
# conn.exec('DROP TABLE foods;')
# conn.exec('CREATE TABLE foods (id SERIAL PRIMARY KEY, name VARCHAR (255), cuisine_type VARCHAR(255), price INTEGER, dollars INTEGER, cents INTEGER, allergens VARCHAR(1000));')
# conn.close

# conn = PG::Connection.open(dbname: 'restaurant_db')
# conn.exec('DROP TABLE parties;')
# conn.exec('CREATE TABLE parties (id SERIAL PRIMARY KEY, table_number INTEGER, number_of_guests INTEGER, paid BOOLEAN);')
# conn.close

# conn = PG::Connection.open(dbname: 'restaurant_db')
# conn.exec('DROP TABLE orders;')
# conn.exec('CREATE TABLE orders (id SERIAL PRIMARY KEY, food_id INTEGER, no_charge BOOLEAN, party_id INTEGER, entered TIMESTAMP, fired BOOLEAN);')
# conn.close   

# conn = PG::Connection.open(dbname: 'restaurant_db')
# conn.exec('DROP TABLE receipts;')
# conn.exec('CREATE TABLE receipts (id SERIAL PRIMARY KEY, table_number INTEGER, food_list VARCHAR (10000), price_list VARCHAR (10000), total VARCHAR(255), time TIMESTAMP);')
# conn.close  



# FOOD CRUD


get '/' do
  # @foods = Food.order(:name)
  @parties = Party.all
  erb :index
end

post '/' do
  party = Party.create(params[:party])
  redirect '/'
end

get '/foods' do
  @foods = Food.order(:name)
  erb :'/foods/index'
end

get '/foods/new' do
  erb :'/foods/new'
end

post '/foods' do
  # food = Food.create({:name => params[:name], :cuisine_type => params[:cuisine_type], :price => 0, :allergens => params[:allergens]})
  food = Food.create(params[:food])
  if food.valid?
    price = food.dollars.to_s + food.cents.to_s
    food.update(price: price)
    redirect '/foods'
  else
    @errors = food.errors.full_messages
    erb :'/foods/new'
  end
end

get '/foods/:id' do
  @food = Food.find(params[:id])
  erb :'/foods/show'
end

get '/foods/:id/edit' do
  @food = Food.find(params[:id])
  erb :'/foods/edit'
end

patch '/foods/:id' do
  food = Food.find(params[:id])
  food.update(params[:food])
  price = food.dollars.to_s + food.cents.to_s
  food.update(price: price)
  redirect "/foods/#{food.id}"
end

delete '/foods/:id' do
  food = Food.find(params[:id])
  food.delete
  redirect '/foods'
end

# PARTY CRUD

# get '/parties' do
#   @parties = Party.all
#   erb :'/parties/index'
# end

get '/parties/new' do
  erb :'/parties/new'
end

get '/parties/:id' do
  @party = Party.find(params[:id])
  @orders = Order.where(:party_id => @party.id)
  erb :'/parties/show'
end

get '/parties/:id/edit' do
  @party = Party.find(params[:id])
  erb :'/parties/edit'
end

patch '/parties/:id' do
  party = Party.find(params[:id])
  party.update(params[:party])
  redirect "/parties/#{party.id}"
end

delete '/parties/:id' do
  party = Party.find(params[:id])
  orders = Order.where(:party_id => party.id).destroy_all
  # orders.destroy
  party.delete
  redirect '/'
end


get '/parties/:id/receipts' do
  @party = Party.find(params[:id])
  @total = params[:total]
  @orders = Order.where(:party_id => @party.id)
  receipt_file = File.open('public/receipt.txt', 'w')
  receipt_file << ""
  receipt_file.close
  receipt_file = File.open('public/receipt.txt', 'a')
  receipt_file << "Receipt for table #{@party.table_number}\n\n"
  @orders.each do |order|
    receipt_file << order.food_name.to_s + ":  $" + order.charge.to_s + "\n"  
  end
  receipt_file << "\n\nSUM:  $" + @total
  receipt_file << "\nTIP:_____________________________"
  receipt_file << "\nTOTAL:_____________________________\n\nSuggested Tip:"
  receipt_file << "\n25% = $" + (@total.to_f * 0.25).round(2).to_s
  receipt_file << "\n20% = $" + (@total.to_f * 0.2).round(2).to_s
  receipt_file << "\n15% = $" + (@total.to_f * 0.15).round(2).to_s
  receipt_file.close
  erb :'/receipts/index'
end

post '/parties/:id/receipts' do
  id = params[:id]
  party = Party.find(id)
  party.update(paid: true)
  Receipt.create(params[:receipt])
  redirect "/parties/#{id}"
end

get '/receipts' do
  @receipts = Receipt.order(time: :desc)
  erb :'/receipts/show'
end

get '/orders' do
  @party_id = params[:party_id]
  @orders = Order.where(party_id: "#{params[:party_id]}")
  @table_number = Party.find("#{params[:party_id]}").table_number
  erb :'/orders/index'
end

get '/orders/new' do
  @party = Party.find(params[:party_id])
  if @party.paid != true
    @orders = Order.where(:party_id => @party.id)
    @foods = Food.order(:name)
    @party_foods = @party.foods
    erb :'/orders/new'
  else
    redirect "/errors/order_on_paid_party"
  end
end

post '/orders' do
  order = Order.create(params[:order])
  party = Party.find(order.party_id)
  redirect "/parties/#{party.id}"
end

get '/orders/:id' do
  @order = Order.find(params[:id])
  @party = Party.find(@order.party_id)
  erb :'/orders/show'
end

get '/orders/:id/edit' do
  @order = Order.find(params[:id])
  @food = Food.find(@order.food_id)
  @foods = Food.order(:name)
  erb :'/orders/edit'
end

patch '/orders/:id' do
  order = Order.find(params[:id])
  party_id = order.party_id
  order.update(params[:order])
  redirect "/parties/#{party_id}"
end


delete '/orders/:id' do
  order = Order.find(params[:id])
  party_id = order.party_id
  order.destroy
  redirect "/parties/#{party_id}"
end


get '/chef' do
  @orders = Order.list_for_chef
  erb :'/foods/chef'
end

post '/chef' do
  order = Order.find(params[:id])
  order.update(:fired => params[:fired])
  redirect '/chef'
end

get '/errors/order_on_paid_party' do
  erb :'/errors/order_on_paid_party'
end













