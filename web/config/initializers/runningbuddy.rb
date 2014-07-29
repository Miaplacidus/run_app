require '../lib/app_helper.rb'

RunPal.db_class = RunPal::Database::ORM
RunPal.env = 'test'
RunPal.db_seed

# RunPal.db_class = Timeline::Database::PostGres
# RunPal.env = 'development'
# RunPal.db_seed

