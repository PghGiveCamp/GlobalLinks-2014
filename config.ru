require 'rack/parser'
require './lib/volunteer_portal/app'

use Rack::Parser, :content_types => {
  'application/json'  => Proc.new { |body| JSON.parse(body) }
}

run Sinatra::Application
