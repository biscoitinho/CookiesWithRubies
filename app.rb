require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require "sinatra/basic_auth"

enable :sessions

class Post < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
end

enable :sessions
set :session_secret, 'secret'

SITE_TITLE = "Songbook"
SITE_DESCRIPTION = "a simple blogging platform"

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

authorize "Admin" do |username, password|
  username == "admin" && password == "admin"
end

get '/' do
  @posts = Post.order("created_at DESC")
  @title = 'All Posts'
  erb :"posts/index"
end

protect "Admin" do
  get '/panel' do
    @posts = Post.order("created_at DESC")
    @title = 'All Posts'
    erb :"posts/panel"
  end

  post '/panel' do
    @post = Post.new(parmas[:post])
    @post.save
    redirect '/posts/panel'
  end

  get "/posts/create" do
    @title = "Create post"
    @post = Post.new
    erb :"posts/create"
  end

  post "/posts" do
    @post = Post.new(params[:post])
    if @post.save
      redirect "posts/#{@post.id}"
    else
      erb :"posts/create"
    end
  end

  get "/posts/:id" do
    @post = Post.find(params[:id])
    @title = @post.title
    erb :"posts/view"
  end

  get "/posts/:id/edit" do
    @post = Post.find(params[:id])
    @title = "Edit Form"
    erb :"posts/edit"
  end

  put "/posts/:id" do
    @post = Post.find(params[:id])
    @post.update(params[:post])
    redirect "/posts/#{@post.id}"
  end
end
