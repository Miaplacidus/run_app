require 'dotenv'
require 'active_model'
require 'active_record'
require 'active_record_tasks'
require 'pry-debugger'
require 'yaml'
require 'time'
require 'geocoder'

Dotenv.load

module RunPal
  def self.db
    @db_class ||= Database::InMemory
    @__db_instance ||= @db_class.new(@env || 'test')
  end

  def self.db_class=(db_class)
    @db_class = db_class
  end

  def self.env=(env_name)
    @env = env_name
  end

  def self.db_seed
    self.db.clear_everything
    # ADD SEED INFORMATION HERE
  end
end

require_relative 'run_pal/entity.rb'
require_relative 'use_case.rb'

Dir["#{File.dirname(__FILE__)}/run_pal/database/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/run_pal/entities/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/run_pal/use_cases/*.rb"].each { |f| require(f) }



