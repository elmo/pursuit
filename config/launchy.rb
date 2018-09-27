require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'
require 'launchy'

client_secrets = Google::APIClient::ClientSecrets.load
auth_client = client_secrets.to_authorization
auth_client.update!(
  :scope => 'https://www.googleapis.com/auth/drive.metadata.readonly',
  :redirect_uri => 'urn:ietf:wg:oauth:2.0:oob'
)

auth_uri = auth_client.authorization_uri.to_s
Launchy.open(auth_uri)

puts 'Paste the code from the auth response page:'
auth_client.code = gets
auth_client.fetch_access_token!

drive = Google::Apis::DriveV2::DriveService.new
drive.authorization = auth_client
files = drive.list_files

files.items.each do |file|
  puts file.title
end
