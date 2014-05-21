#encoding : utf-8
require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'
require './models/article'
require './models/user'
require './models/category'

set :database, {adapter: "sqlite3", database: "development.sqlite3"}

a = User.find(1)
a.password = "mayflyorg"
a.introduction = "三无废柴宅，程序猿，假文科生，怕死，中二病，玻璃心。有胡思乱想之怪癖，屡禁不止，无药可医。

15566271681 / 201460060 / cichol@live.cn"
a.save