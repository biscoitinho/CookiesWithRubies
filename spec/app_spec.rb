require_relative '../app.rb'
require 'rspec'
require 'rack/test'

set :environment, :test

describe 'App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should load the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should not load the panel page" do
    get '/posts'
    expect(last_response).to_not be_ok
  end

  it "renders create post page" do
    get '/posts/create'
    expect(last_response).to be_ok
    expect(last_response.body).to include("Create Post")
  end

  it "renders create post page" do
    get '/posts/1'
    expect(last_response).to_not be_ok
  end
end
