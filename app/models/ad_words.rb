require 'adwords_api'
#require 'chronic'
class AdWords
   attr_accessor :client
   attr_accessor :client_customer_id
   attr_accessor :customers
   attr_accessor :campaigns
   attr_accessor :child_accounts
   attr_accessor :managed_customer_service
   attr_accessor :child_account_entries
   attr_accessor :child_account_links
   attr_accessor :unique_client_customer_ids
   attr_accessor :account_map
   attr_accessor :account_hidden_map
   attr_accessor :redis
   attr_accessor :token
   attr_accessor :configs

   PAGE_SIZE = 50
   CLIENT_IDS = [8173901894, 1013522257, 3937774822]

  def initialize(id)
   @client_customer_id = id
   #@client ||= init_from_config
   @client ||= init_from_hash
   authorize!
  end

  def authorize!
   @redis = Redis.new
   token = get_stored_auth_token
   refreshed_token = client.authorize({:oauth2_token => token})
   redis.set(client_customer_id, refreshed_token.to_json)
  end

  def init_from_config
    AdwordsApi::Api.new("config/#{client_customer_id}.yml")
  end

  def init_from_hash
    AdwordsApi::Api.new(config_hash)
  end

  def get_stored_auth_token
   @token = JSON.parse(redis.get(client_customer_id) )
  end

  def refresh_token
    (token.present?) ? token['refresh_token']  : ''
  end

  def issued_at
    (token.present?) ? token['issued_at']  : ''
  end

  def expires_in
    (token.present?) ? token['expires_in']  : ''
  end

  def id_token
    (token.present?) ? token['id_token']  : ''
  end

  def config_hash
    {
      :authentication => {
        :method => 'OAuth2',
        :oauth2_client_id => '178517224030-mqs6ap9d5aup4uanh07boli2aes1nfmk.apps.googleusercontent.com',
        :oauth2_client_secret => 'HUkGO79L64ZrDNMJ4F-OnPtB',
        :developer_token => 'ePLafod1j5naoIH12Iz0sw',
        :client_customer_id => client_customer_id,
        :user_agent => user_agent,
        :oauth2_token => { :refresh_token => refresh_token },
        :additional_parameters => {"access_type" => "offline"}
      },
      :service => { :environment => 'PRODUCTION' }
    }
  end

  def user_agent
    'Ruby Falcon'
  end

  def active_client_customer_ids
    #[8173901894, 1013522257, 3937774822]
    [3937774822]
  end

  def self.refresh_tokens!
    @configs = []
    CLIENT_IDS.each { |id| @configs << AdWords.new(id) }
  end

  def self.test_loop
    loop do
       p "time is: " + Time.zone.now.to_s
       c = AdWords.new(3937774822)
       p c.authorize!
       sleep(60)
    end
  end

  def self.test_config!(config)
    p "testing config #{config.client_customer_id}"
    begin
      config.get_campaigns
      p "valid"
      p "token expires in: " + config.expires_in.to_s
      expiry =  Chronic.parse(config.issued_at.to_s) + config.expires_in.seconds
      p "issued at: " + Chronic.parse(config.issued_at.to_s).strftime("%B %d, %Y %H:%M:%S %P")
      p "expires: " + expiry.strftime("%B %d, %Y %H:%M:%S %P ")
      p config.token
    rescue AdwordsApi::V201806::CampaignService::ApiException
      p "token expires in: " + config.expires_in.to_s
      expiry =  Chronic.parse(config.issued_at.to_s) + config.expires_in.seconds
      p "issued at: " + Chronic.parse(config.issued_at.to_s).strftime("%B %d, %Y %H:%M:%S %P")
      p "expires: " + expiry.strftime("%B %d, %Y %H:%M:%S %P ")
      p "token invalid"
    end
  end

  def self.test_configs!
    refresh_tokens!
    @configs.each  { |conf| test_config!(conf)  }
    nil
  end

  def update_campaigns
     get_campaigns
     @campaigns.each do |campaign|
       c = Campaign.find_by(campaign_id: campaign[:id].to_s)
       if c.present?
         c.update_attributes(name: campaign[:name], status: campaign[:status], budget: campaign[:budget] )
       else
         Campaign.create!(client_customer_id: '3937774822' , campaign_id: campaign[:id].to_s, name: campaign[:name], status: campaign[:status], budget: campaign[:budget] )
       end
     end
  end

  def process_accounts
    get_child_accounts
    @account_hidden_map.keys.sort.each do |client_customer_id|
      process_account(client_customer_id) if !@account_hidden_map[client_customer_id]
    end
  end

  def process_account(client_customer_id)
    account_name = @account_map[client_customer_id]
    p "pocessing account #{account_name} id: #{client_customer_id}"
  end

  def campaign_service
    client.service(:CampaignService)
  end

  def get_child_accounts
    @customers = customer_service.get_customers
    client.credential_handler.set_credential(:client_customer_id, customers.first[:customer_id])
    @managed_customer_service = @client.service(:ManagedCustomerService)
    selector = {:fields => ['CustomerId', 'Name']}
    @child_accounts = @managed_customer_service.get(selector)
    @child_account_entries =  @child_accounts[:entries]
    @child_account_links =  @child_accounts[:links]
    @unique_client_customer_ids = @child_account_links.collect {|x| x[:client_customer_id] }.uniq
    @account_map = {}
    @child_account_entries.each do |h|
      @account_map[ h[:customer_id] ] =  h[:name]
    end
    @account_hidden_map = {}
    @child_account_links.each do |a|
      @account_hidden_map[ a[:client_customer_id] ]  = a[:is_hidden]
    end
  end

  def get_campaigns
     @campaigns = []
     campaign_srv = client.service(:CampaignService)
     selector = {
       :fields => ['Id', 'Name', 'Status'],
       :ordering => [ {:field => 'Name', :sort_order => 'ASCENDING'} ],
       :paging => {
         :start_index => 0,
         :number_results => PAGE_SIZE
        }
      }
     offset, page = 0, {}
  begin
    page = campaign_srv.get(selector)
    if page[:entries]
      page[:entries].each do |campaign|
        @campaigns << campaign
        puts "Campaign ID %d, name '%s' and status '%s'" %
            [campaign[:id], campaign[:name], campaign[:status]]
      end
      offset += PAGE_SIZE
      selector[:paging][:start_index] = offset
    end
  end while page[:total_num_entries] > offset

  if page.include?(:total_num_entries)
    puts "\tTotal number of campaigns found: %d." % [page[:total_num_entries]]
  end

  end
end
