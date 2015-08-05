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
  params = JSON.parse @request_payload.strip.gsub(/\s+/, ' ')
  puts params

  base_uri = 'https://bouncer36.firebaseio.com/'
  puts base_uri
  firebase = Firebase::Client.new(base_uri)
  firebase.push('bouncer36', {name: 'requested_at', text: "#{Time.now}", ip: request.ip })

  content_type :json
  # Sending
  {
    customer_id: params['customer_id'],
    company_id: params['company_id'],
    amount: params['amount'],
    currency: params['currency'],
    number:  8.times.map { [*'0'..'9', *'a'..'z'].sample }.join,
    status: 'generated'
  }.to_json
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

