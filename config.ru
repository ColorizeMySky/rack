# frozen_string_literal: true

require_relative 'lib/time_formatter'
require_relative 'app'

ROUTES = {
  '/time' => App.new
}

use Rack::ContentType, 'text/plain'
run Rack::URLMap.new(ROUTES)
