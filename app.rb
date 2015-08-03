require 'sinatra'
require 'firebase'
require 'net/http'
require 'uri'
require 'json'
require 'rest-client'

require './lib/request'
use Rack::Logger

configure do
  file = File.new("#{settings.root}/log/common.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

before do
  request.body.rewind
  @request_payload = request.body.read
end

AUTH_USER = 'bounce'
AUTH_PASS = 'pass'
URL = 'http://localhost:3000/api/v1/vouchers'

get '/ping' do
  'Why you are pinging me!@#@##@#!!! Okay, Here is PONG...happy?!!'
end

get '/' do
  erb :index
end

post '/voucher_eligible' do
  authorize!
  puts @request_payload
  base_uri = 'https://bouncer36.firebaseio.com/'
  puts base_uri
  firebase = Firebase::Client.new(base_uri)
  firebase.push('bouncer36', {name: 'requested_at', text: "#{Time.now}"})

  # Sending
  body = {
    customer_id: 1,
    company_id: 1,
    amount: 200.25,
    currency: 'USD',
    number: 'XJiX 12-NV',
    status: 'generated'
  }
  # obj = PostRequest.new(URL, @request_payload, 'blizzard', '123123123').submit
  # puts obj
  # RestClient.post URL, body, { :Authorization => 'blizzard 123123123' }
end

helpers do
  def authorize!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized"
  end

  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and
      @auth.basic? and
      @auth.credentials and
      @auth.credentials == [AUTH_USER, AUTH_PASS]
  end
end

