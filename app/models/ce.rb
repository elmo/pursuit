class Ce < ApplicationRecord

def self.cols
  [
    :grouping_date, :lead_request_users, :lead_users, :leads, :leads_by_lead_users, :unreconciled_publisher_lead_revenue, :clickout_impressions,
    :clickouts, :clickthrough_rate, :unreconciled_publisher_clickout_revenue, :unreconciled_publisher_total_revenue, :source_code,
    :tracking_code, :adult_lead_request_users, :adult_lead_users, :adult_leads, :adult_leads_by_lead_users, :adult_unreconciled_publisher_lead_revenue,
    :adult_clickouts, :adult_clickout_revenue, :hs_lead_request_users, :hs_lead_users, :hs_leads, :hs_leads_by_lead_users,
    :hs_unreconciled_published_clickout_revenue, :hs_clickouts, :hs_clickout_revenue
  ]
end

end
