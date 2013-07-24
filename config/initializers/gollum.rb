# Initializer for wiki engine
#
require "rubygems"
require "gollum/app"
gollum_path = Rails.root.join('wiki').to_s
Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:default_markup, :markdown)
Precious::App.set(:wiki_options, {})
