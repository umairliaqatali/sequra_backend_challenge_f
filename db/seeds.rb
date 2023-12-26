# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
puts "Starting db:seed process"
Rake::Task['import_csv:import_merchants'].invoke
Rake::Task['import_csv:import_orders'].invoke
puts "Finished db:seed process"
