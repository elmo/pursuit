require 'google/apis/drive_v2'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

class GoogleDrive
  CONF = '/app/config/'
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'Ruby Falcon'.freeze
  CREDENTIALS_PATH = CONF + 'google_drive_client_secret.json'.freeze
  TOKEN_PATH =  CONF + 'token.yaml'.freeze
  SCOPE = "https://www.googleapis.com/auth/drive"
  Drive = Google::Apis::DriveV2

  def initialize
  end

  def authorize
    client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts "Open the following URL in the browser and enter the resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code( user_id: user_id, code: code, base_url: OOB_URI)
    end
     credentials
  end

  def save_file_to_drive(path, file_name)
    drive = Drive::DriveService.new
    drive.authorization = authorize
    metadata = Drive::File.new(title: file_name)
    metadata = drive.insert_file(metadata, upload_source: path, content_type: 'text/csv')
  end

end

