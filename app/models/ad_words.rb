require 'adwords_api'
class AdWords
   attr_accessor :client
   PAGE_SIZE = 50

  def initialize
   @client = AdwordsApi::Api.new('config/adwords_api.yml')
  end

  def get_campaigns
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
