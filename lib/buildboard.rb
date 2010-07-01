require 'rubygems'
require 'sinatra'
require 'cijoe/build'

class Buildboard < Sinatra::Base
  get '/' do
    "Hello World!"
  end
  
  post '/' do
    p params
    "Accepted"
  end
end
