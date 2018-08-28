require 'ad_manager_api'
class AdManager
   attr_accessor :api
  def initialize
     @api = api
  end

  def api
    AdManagerApi::Api.new('config/ad_manager_api.yml')
  end

end
