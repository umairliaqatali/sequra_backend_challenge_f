disbursement_log_file = File.join(Rails.root, 'log', 'disbursement_errors.log')
DISBURSEMENT_LOGGER = ActiveSupport::Logger.new(disbursement_log_file, 'daily', 10.megabytes)

