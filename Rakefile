require 'rubygems'
require './application'
require 'sequel/extensions/migration'

task :environment do
  APP = StripeReporter::Application.new
  DB = Sequel.connect(StripeReporter::Application.settings.database_url)
end

namespace :db do
  task :migrate => :environment do
    Sequel::Migrator.apply(DB, 'migrate')
  end
end

task :console do
  IRB.setup(nil)
  irb = IRB::Irb.new
  IRB.conf[:MAIN_CONTEXT] = irb.context
  irb.context.evaluate("require 'irb/completion'", 0)
  irb.context.evaluate("APP = StripeReporter::Application.new", 0)
  irb.context.evaluate("DB = Sequel.connect(StripeReporter::Application.settings.database_url)", 0)

  trap("SIGINT") do
    irb.signal_handle
  end
  catch(:IRB_EXIT) do
    irb.eval_input
  end
end
