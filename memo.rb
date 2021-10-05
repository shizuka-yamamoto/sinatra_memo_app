require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = Dir.glob("memos/*").map do |file|
    JSON.parse(File.read(file), symbolize_names: true)
  end
  @memos = @memos.sort_by { |file| file[:time] }
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
