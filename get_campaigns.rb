#!/usr/bin/env ruby
require 'optparse'
require 'google/ads/googleads'

def get_campaigns(customer_id)
  client = Google::Ads::Googleads::GoogleadsClient.new('config/googleads_config.rb')
  ga_service = client.service(:GoogleAds)
  response = ga_service.search( customer_id, 'SELECT campaign.id, campaign.name FROM campaign ORDER BY campaign.id', page_size: PAGE_SIZE)
  response.each do |row|
    puts sprintf("Campaign with ID %d and name '%s' was found.",
        row.campaign.id, row.campaign.name)
  end
end

if __FILE__ == $0
  PAGE_SIZE = 1000
  options = {}
  options[:customer_id] = '9750452965'
  OptionParser.new do |opts|
    opts.banner = sprintf('Usage: %s [options]', File.basename(__FILE__))
    opts.separator ''
    opts.separator 'Options:'
    opts.on('-C', '--customer-id CUSTOMER-ID', String, 'Customer ID') do |v|
      options[:customer_id] = v
    end
    opts.separator ''
    opts.separator 'Help:'
    opts.on_tail('-h', '--help', 'Show this message') do
      puts opts
      exit
    end
  end.parse!

  begin
    get_campaigns(options[:customer_id])
  rescue Google::Ads::Googleads::Errors::GoogleAdsError => e
    e.failure.errors.each do |error|
      STDERR.printf("Error with message: %s\n", error.message)
      if error.location
        error.location.field_path_elements.each do |field_path_element|
          STDERR.printf("\tOn field: %s\n", field_path_element.field_name)
        end
      end
      error.error_code.to_h.each do |k, v|
        next if v == :UNSPECIFIED
        STDERR.printf("\tType: %s\n\tCode: %s\n", k, v)
      end
    end
  rescue Google::Gax::RetryError => e
    STDERR.printf("Error: '%s'\n\tCause: '%s'\n\tCode: %d\n\tDetails: '%s'\n" \
        "\tRequest-Id: '%s'\n", e.message, e.cause.message, e.cause.code,
                  e.cause.details, e.cause.metadata['request-id'])
  end
end
