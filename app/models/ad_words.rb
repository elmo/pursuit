require 'google/ads/googleads'
class AdWords
   attr_accessor :client
   PAGE_SIZE = 10
   CUSTOMER_ID = '975-045-2965'

  def initialize
   @client = Google::Ads::Googleads::GoogleadsClient.new('config/googleads_config.rb')
  end

  def get_campaigns
    ga_service = client.service(:GoogleAds)
    response = ga_service.search('975-045-2965', 'SELECT campaign.id, campaign.name FROM campaign ORDER BY campaign.id', page_size: 1000)
    response.each do |row|
      puts sprintf("Campaign with ID %d and name '%s' was found.",
        row.campaign.id, row.campaign.name)
    end
  end
end
