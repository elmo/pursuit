require 'optparse'
require 'googleauth'

def authenticate_in_standalone_application(client_id, client_secret)
  client_id = Google::Auth::ClientId.new(client_id, client_secret)
  user_authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, nil, CALLBACK_URI)
  authorization_url = user_authorizer.get_authorization_url()
  printf("Paste this url in your browser:\n%s\n", authorization_url)
  printf("Type the code you received here: ")
  authorization_code = gets.chomp
  user_credentials = user_authorizer.get_credentials_from_code(code: authorization_code)
  printf("Your refresh token is: %s\n", user_credentials.refresh_token)
  printf("Copy your refresh token above into your googleads_config.rb in your home directory or use it when instantiating the library.\n")
end

if __FILE__ == $PROGRAM_NAME
  CALLBACK_URI = 'urn:ietf:wg:oauth:2.0:oob'
  SCOPE = 'https://www.googleapis.com/auth/adwords'
  options = {}
  options[:client_id] = '1024167817881-3pre5mglugkirshqdqqc53bie7jhjuif.apps.googleusercontent.com'
  options[:client_secret] = 'ITB4BdpMJt7KNcFqQzzck3j5'
  OptionParser.new do |opts|
    opts.banner = sprintf('Usage: %s [options]', File.basename(__FILE__))
    opts.separator ''
    opts.separator 'Options:'
    opts.on('-I', '--client-id CLIENT-ID', String, 'Client ID') do |v|
      options[:client_id] = v
    end
    opts.on('-S', '--client-secret CLIENT-SECRET', String,
        'Client Secret') do |v|
      options[:client_secret] = v
    end
    opts.separator ''
    opts.separator 'Help:'
    opts.on_tail('-h', '--help', 'Show this message') do
      puts opts
      exit
    end
  end.parse!
  authenticate_in_standalone_application(options[:client_id], options[:client_secret])
end
