require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'svg_inline_file_extractor'
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }
require 'pry'
