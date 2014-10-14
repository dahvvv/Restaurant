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
  @foods = Food.all
  @parties = Party.all
  erb :index
end

get '/foods' do
  @foods = Food.all
  erb :'/foods/index'
end

get '/foods/new' do
  erb :'/foods/new'
end

post '/foods' do
  food = Food.create(params[:food])
  redirect '/foods'
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
  erb :'/orders/index'
end

get '/orders/new' do
  @party = Party.find(params[:party_id])
  erb :'/orders/new'
end

post '/orders' do
  order = Order.create(params[:order])
  party = Party.find(order.party_id)
  # party = Party.find(params[:party_id])
  redirect "/parties/#{party.id}"
end

