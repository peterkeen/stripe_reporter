require 'rubygems'
require 'sequel-reporter'

module StripeReporter
  class Application < Sequel::Reporter::Application
    # Set this to the URL for your database. Remember to
    # uncomment the correct gem in the Gemfile for your
    # sequel adapter.
    set :database_url, 'sqlite:///'

    # Set this to the report that should be used for your index
    set :index_report, :dashboard

    # Set this to the base directory for the app
    set :root, File.expand_path("..", __FILE__)
  end
end
