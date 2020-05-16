require 'sinatra'
require 'json'
require 'base64'

configure do
  enable :logging
end

get '/' do
  erb :index
end

post '/convert' do
  request_body = JSON.parse(request.body.read)
  ext = request_body['image'].match(%r[\Adata:.+?/(?<ext>.+?);base64,])['ext']
  file = Base64.decode64(request_body['image'].gsub(%r[\Adata:.+?/.+?;base64,], ''))
  File.open("image.#{ext}", 'wb') { |f| f.print file }
  puts `convert -geometry #{request_body['size']} image.#{ext} out.png`
  send_file "out.png"
end