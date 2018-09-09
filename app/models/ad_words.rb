require 'adwords_api'
class AdWords
   attr_accessor :client
   attr_accessor :customers
   attr_accessor :campaigns
   attr_accessor :child_accounts
   attr_accessor :managed_customer_service
   attr_accessor :child_account_entries
   attr_accessor :child_account_links
   attr_accessor :unique_client_customer_ids
   attr_accessor :account_map
   attr_accessor :account_hidden_map

   PAGE_SIZE = 50

  def initialize
   @client ||= AdwordsApi::Api.new('config/adwords_api.yml')
  end

  def customer_service
    client.service(:CustomerService)
  end

  def update_campaigns
     get_campaigns
     @campaigns.each do |campaign|
       c = Campaign.find_by(campaign_id: campaign[:id].to_s)
       if c.present?
         c.update_attributes(name: campaign[:name], status: campaign[:status], budget: campaign[:budget] , status: campaign[:status] )
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
