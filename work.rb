#encoding : utf-8
require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'
require './models/article'
require './models/user'
require './models/category'

set :database, {adapter: "sqlite3", database: "development.sqlite3"}

a = Article.find(7)
