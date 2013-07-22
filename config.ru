# This file is used by Rack-based servers to start the application.

require "rubygems"
require "gollum/app"
gollum_path = Rails.root.join('wiki').to_s
Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:wiki_options, {})

require ::File.expand_path('../config/environment',  __FILE__)
run Steelers::Application
