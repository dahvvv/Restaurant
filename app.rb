require 'bundler'
Bundler.require

ROOT_DIR = 

conn = PG::Connection.open()
conn.exec('DROP DATABASE IF EXISTS restaurant_db;')
conn.exec('CREATE DATABASE restaurant_db;')
conn.close

conn = PG::Connection.open(dbname: 'restaurant_db')
conn.exec('CREATE TABLE foods (id SERIAL PRIMARY KEY, name VARCHAR (255), cuisine_type VARCHAR(255), price INTEGER, allergens VARCHAR(1000));')
conn.close

ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  databse: 'restaurant_db'
  })



