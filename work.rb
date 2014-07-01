#encoding : utf-8

require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'
require './models/article'
require './models/user'
require './models/category'
require './models/article_comment'
require './models/site_config'

set :database, {adapter: "sqlite3", database: "development.sqlite3"}

u = User.find(1)
u.password = Digest::MD5.hexdigest(Digest::MD5.hexdigest("mayflyorg"))
u.save