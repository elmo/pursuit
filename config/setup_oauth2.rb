require 'adwords_api'
ENV['HOME'] = '/Users/elliott/pursuit/config'

def setup_oauth2()
  adwords = AdwordsApi::Api.new
  token = adwords.authorize() do |auth_url|
    puts "Hit Auth error, please navigate to URL:\n\t%s" % auth_url
    print 'log in and type the verification code: '
    verification_code = gets.chomp
    verification_code
  end

  if token
    print "\nWould you like to update your adwords_api.yml to save " + "OAuth2 credentials? (y/N): "
    response = gets.chomp
    if ('y'.casecmp(response) == 0) or ('yes'.casecmp(response) == 0)
      adwords.save_oauth2_token(token)
      puts 'OAuth2 token is now saved to ~/adwords_api.yml and will be automatically used by the library.'
    end
  end

  # token = adwords.authorize({:oauth2_verification_code => verification_code})
  # Note, 'token' is a Hash. Its value is not used in this example. If you need
  # to be able to access the API in offline mode, with no user present, you
  # should persist it to be used in subsequent invocations like this:
  # adwords.authorize({:oauth2_token => token})
  # No exception thrown - we are good to make a request.
end

if __FILE__ == $0
  API_VERSION = :v201802

  begin
    setup_oauth2()

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
