require 'adwords_api'
class AdWords
   attr_accessor :api

  def initialize
     @api = api
  end

  def api
    AdwordsApi::Api.new('config/ad_manager_api.yml')
  end

  def campaign_service
    api.service(:CampaignService, :v201802)
 end

 def campaigns
    service = api.service(:CampaignService, get_api_version())
    selector = {
      :fields => ['Id', 'Name', 'Status'],
      :ordering => [{:field => 'Id', :sort_order => 'ASCENDING'}],
      :paging => {:start_index => 0, :number_results => 50 }
    }
    service.get(selector)
 end

end
