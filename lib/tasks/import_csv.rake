require 'csv'
namespace :import_csv do
  desc 'Import Merchants from CSV'
  task import_merchants: :environment do
    file_name = File.join(Rails.root, 'db', 'seeds', 'merchants.csv')
    failed_rows = []
    puts "Starting import_csv:import_merchants task: #{Time.now}"
    CSV.foreach(file_name, headers: true, header_converters: :symbol, col_sep: ';').each_with_index do |row, index|
      begin
        Merchant.find_or_create_by!(reference: row[:reference]) do |merchant|
          merchant.email = row[:email]
          merchant.live_on = begin
                               Date.parse(row[:live_on])
                             rescue
                               nil
                             end
          merchant.disbursement_frequency = row[:disbursement_frequency]
          merchant.minimum_monthly_fee = BigDecimal(row[:minimum_monthly_fee])
          merchant.save!
        end
      rescue StandardError => e
        failed_rows << { index: index + 1, reference: row[:reference], error: e.message }
      end
    end

    if failed_rows.empty?
      puts 'Merchants imported successfully!'
    else
      puts "#{failed_rows.count} rows failed to import. Details:"
      failed_rows.each do |row_info|
        puts "Row #{row_info[:index]} (Reference: #{row_info[:reference]}): #{row_info[:error]}"
      end
    end
    puts "Finished import_csv:import_merchants task #{Time.now}"
  end

  desc 'Import Orders from CSV'
  task import_orders: :environment do
    file_name = File.join(Rails.root, 'db', 'seeds', 'orders.csv')
    log_file_path = File.join(Rails.root, 'log', 'order_import_errors.log')
    failed_rows = []
    orders_to_import = []
    puts "*********************** Starting import_csv:import_orders task #{Time.now}"
    File.open(log_file_path, 'a') do |log_file|
      CSV.foreach(file_name, headers: true, header_converters: :symbol, col_sep: ';') do |row|
        merchant = Merchant.find_by(reference: row[:merchant_reference])

        if merchant.present?
          order = Order.new(
            merchant: merchant,
            amount: row[:amount],
            created_at: row[:created_at]
          )

          if order.valid?
            orders_to_import << order
          else
            failed_row_info = "Row invalid: #{order.errors.full_messages.join(', ')}"
            log_file.puts(failed_row_info)
            failed_rows << failed_row_info
          end
        else
          error_message = "Merchant with reference #{row[:merchant_reference]} not found."
          log_file.puts(error_message)
          failed_rows << error_message
        end

        if orders_to_import.size >= 10000
          Order.import(orders_to_import)
          orders_to_import.clear
        end
      end

      # Import any remaining orders
      Order.import(orders_to_import) unless orders_to_import.empty?

      if failed_rows.empty?
        puts 'Orders imported successfully!'
      else
        puts "#{failed_rows.count} rows failed to import. Details logged in #{log_file_path}"
      end
    end
    puts "*********************** Finished import_csv:import_orders task #{Time.now}"
  end
end
