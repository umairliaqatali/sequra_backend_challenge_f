# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
**Prerequisites:**
1. Ruby 3.0.0
2. Rails 7
3. PostgreSQl
4. Redis

seed files should be place in db/seeds/ e.g db/seeds/merchants.csv
run following command to view results. 
rails db:setup 

for sidekiq use 
bundle exec sidekiq -C config/sidekiq.yml

#### assumptions ###
The phrase 'Lastly, on the first disbursement of each month' is somewhat ambiguous. It's unclear whether it pertains to
each merchant individually or to the start of the month in general. Moreover, if it relates specifically to disbursements
, then an after_create callback could be employed to conditionally invoke the calculate_and_record_fee method. This would
be applicable for the first disbursement of each merchant in a given month.
  
#### Missing ###
1. Test coverage can be improved. Was not able to write test cases for background jobs due to time shortage.
2. Background jobs could be improved to run one job for each merchant

results
---------------------------
year 2022
Number of disbursements: 1509
Amount disbursed to merchants: 36929320.27
Amount of order fees 333677.15
Number of monthly fees charged (From minimum monthly fee): 12
Amount of monthly fee charged (From minimum monthly fee): 197.55
---------------------------
year 2023
Number of disbursements: 10391
Amount disbursed to merchants: 188564599.51
Amount of order fees 1709260.98
Number of monthly fees charged (From minimum monthly fee) 67
Amount of monthly fee charged (From minimum monthly fee) 1130.94