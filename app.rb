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
# conn.exec('CREATE TABLE foods (id SERIAL PRIMARY KEY, name VARCHAR (255), cuisine_type VARCHAR(255), price INTEGER, allergens VARCHAR(1000));')
# conn.close

# conn = PG::Connection.open(dbname: 'restaurant_db')
# conn.exec('DROP TABLE parties;')
# conn.exec('CREATE TABLE parties (id SERIAL PRIMARY KEY, table_number INTEGER, number_of_guests INTEGER, paid BOOLEAN);')
# conn.exec('INSERT INTO TABLE parties (table_number 666, number_of_guests 20, paid false, orders')
# conn.close

# conn = PG::Connection.open(dbname: 'restaurant_db')
# conn.exec('DROP TABLE orders;')
# conn.exec('CREATE TABLE orders (id SERIAL PRIMARY KEY, food_id INTEGER, party_id INTEGER);')
# conn.close  



# FOOD CRUD
get '/' do
  @foods = Food.order(:name)
  @parties = Party.all
  erb :index
end

get '/foods' do
  @foods = Food.order(:name)
  erb :'/foods/index'
end

get '/foods/new' do
  erb :'/foods/new'
end

post '/foods' do
  food = Food.create(params[:food])
  if food.valid?
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
  redirect "/foods/#{food.id}"
end

delete '/foods/:id' do
  food = Food.find(params[:id])
  food.delete
  redirect '/foods'
end

# PARTY CRUD

get '/parties' do
  @parties = Party.all
  erb :'/parties/index'
end

get '/parties/new' do
  erb :'/parties/new'
end

post '/parties' do
  party = Party.create(params[:party])
  redirect '/parties'
end

get '/parties/:id' do
  @party = Party.find(params[:id])
  @foods = @party.foods
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
  party.delete
  redirect '/parties'
end


get '/orders' do
  # party = Party.find(params[:party_id])
  @orders = Order.where(party_id: "#{params[:party_id]}")
  @table_number = Party.find("#{params[:party_id]}").table_number
  erb :'/orders/index'
end

get '/orders/new' do
  @party = Party.find(params[:party_id])
  @foods = Food.order(:name)
  @party_foods = @party.foods
  erb :'/orders/new'
end

post '/orders' do
  order = Order.create(params[:order])
  party = Party.find(order.party_id)
  redirect "/parties/#{party.id}"
end

get '/orders/:id' do
  @order = Order.find(params[:id])
  @food = Food.find(@order.food_id)
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



