require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  redirect to('/memos')
end

get '/memos' do
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do

end

get '/memos/:id' do
  erb :show
end

get '/memos/:id/edit' do
  erb :edit
end

patch '/memos/:id' do

end

delete '/memos/:id' do

end
