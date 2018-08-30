require 'google/ads/googleads'

adwords = Google::Ads::Googleads::GoogleadsClient.new do |c|
  c.client_id = '1024167817881-3pre5mglugkirshqdqqc53bie7jhjuif.apps.googleusercontent.com'
  c.client_secret = 'XIHIWsv4X1rEMCCxGuOq-Feh'
  c.refresh_token = '1/zQi2Md1PawuT4KlObVn-m1wQICmFfHdkg3DMOVKaBng'
  c.developer_token = 'ePLafod1j5naoIH12Iz0sw'
end

p adwords
