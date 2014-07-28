require 'dotenv'
Dotenv.load

require '../lib/app_helper.rb'

RunPal.db_seed

# RunPal.db_class = Timeline::Database::PostGres
# RunPal.env = 'development'
# RunPal.db_seed

