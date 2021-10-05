require 'sinatra'
require 'sinatra/reloader'
require 'json'

class Memo
  def self.create(title:, content:)
    memo = {id: SecureRandom.uuid, title: title, content: content, time: Time.now}
    File.open("memos/#{memo[:id]}.json", 'w') do |file|
      file.puts JSON.pretty_generate(memo)
    end
  end

  def self.find(id:)
    JSON.parse(File.read("memos/#{id}.json"), symbolize_names: true)
  end

  
end


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
  Memo.create(title: params[:title], content: params[:content])
  redirect to('/memos')
end

get '/memos/:id' do
  @memo = Memo.find(id: params[:id])
  erb :show
end

get '/memos/:id/edit' do
  erb :edit
end

patch '/memos/:id' do

end

delete '/memos/:id' do

end
