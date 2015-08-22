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
    get '/panel'
    expect(last_response).to_not be_ok
  end
end
