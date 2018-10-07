#!/usr/bin/env ruby
require 'adwords_api'
require 'date'

def use_runtime_config(client_id, client_secret, refresh_token,
        developer_token, client_customer_id, user_agent)
  # AdwordsApi::Api will read a config file from ENV['HOME']/adwords_api.yml
  # when called without parameters.
  adwords = AdwordsApi::Api.new({
    :authentication => {
      :method => 'OAuth2',
      :oauth2_client_id => client_id,
      :oauth2_client_secret => client_secret,
      :developer_token => developer_token,
      :client_customer_id => client_customer_id,
      :user_agent => user_agent,
      :oauth2_token => {
        :refresh_token => refresh_token
      }
    },
    :service => {
      :environment => 'PRODUCTION'
    }
  })

  # To enable logging of SOAP requests, set the log_level value to 'DEBUG' in
  # the hash above or provide your own logger:
  # adwords.logger = Logger.new('adwords_xml.log')

  customer_srv = adwords.service(:CustomerService)
  customer = customer_srv.get()
  puts "You are logged in as customer: %d" % customer[:id]
end

if __FILE__ == $0
  API_VERSION = :v201710

  begin
    client_id = '178517224030-mqs6ap9d5aup4uanh07boli2aes1nfmk.apps.googleusercontent.com'
    client_secret = 'HUkGO79L64ZrDNMJ4F-OnPtB'
    refresh_token = '1/liIOQib-Ch4k1MnpBdkkGkCtplA1nZrinrubTXyn9f8'
    developer_token = 'ePLafod1j5naoIH12Iz0sw'
    client_customer_id = '3937774822'
    user_agent = 'Ruby Falcon'

    use_runtime_config(client_id, client_secret, refresh_token, developer_token, client_customer_id, user_agent)

  # Authorization error.
  rescue AdsCommon::Errors::OAuth2VerificationRequired => e
    puts "Authorization credentials are not valid. Edit adwords_api.yml for " +
        "OAuth2 client ID and secret and run misc/setup_oauth2.rb example " +
        "to retrieve and store OAuth2 tokens."
    puts "See this wiki page for more details:\n\n  " +
        'https://github.com/googleads/google-api-ads-ruby/wiki/OAuth2'

  # HTTP errors.
  rescue AdsCommon::Errors::HttpError => e
    puts "HTTP Error: %s" % e

  # API errors.
  rescue AdwordsApi::Errors::ApiException => e
    puts "Message: %s" % e.message
    puts 'Errors:'
    e.errors.each_with_index do |error, index|
      puts "\tError [%d]:" % (index + 1)
      error.each do |field, value|
        puts "\t\t%s: %s" % [field, value]
      end
    end
  end
end
