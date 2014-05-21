#encoding : utf-8
require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'
require './models/article'
require './models/user'
require './models/category'
require './models/article_comment'

set :database, {adapter: "sqlite3", database: "development.sqlite3"}

ArticleComment.delete [1,2,4]