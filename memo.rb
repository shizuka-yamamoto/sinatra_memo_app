# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

class Memo
  def initialize(id:, title:, content:, time:)
    @id = id
    @title = title
    @content = content
    @time = time
  end

  def self.create(title:, content:)
    memo = { id: SecureRandom.uuid, title: title, content: content, time: Time.now }
    File.open("memos/#{memo[:id]}.json", 'w') do |file|
      file.puts JSON.pretty_generate(memo)
    end
  end

  def self.find(id:)
    JSON.parse(File.read("memos/#{id}.json"), symbolize_names: true)
  end

  def update
    memo = { id: @id, title: @title, content: @content, time: @time }
    File.open("memos/#{@id}.json", 'w') do |file|
      file.puts JSON.pretty_generate(memo)
    end
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = Dir.glob('memos/*').map do |file|
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
  @memo = Memo.find(id: params[:id])
  erb :edit
end

patch '/memos/:id' do
  memo = Memo.new(id: params[:id], title: params[:title], content: params[:content], time: Time.now)
  memo.update
  redirect to('/memos')
end

delete '/memos/:id' do
  File.delete("memos/#{params[:id]}.json")
  redirect to('/memos')
end
