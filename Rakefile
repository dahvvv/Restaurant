require 'bundler'
Bundler.require

require 'sinatra/activerecord/rake'
require './connection'

namespace :db do

  desc 'create database restaurant_db'
  task :create_db do
    conn = PG::Connection.open()
    conn.exec('CREATE DATABASE restaurant_db;')
    conn.close
  end

  desc 'drop database restaurant_db'
  task :drop_db do
    conn = PG::Connection.open()
    conn.exec('DROP DATABASE restaurant_db;')
    conn.close
  end

end
