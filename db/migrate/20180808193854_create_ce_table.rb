class CreateCeTable < ActiveRecord::Migration[5.1]
  def change
    create_table :ces do |t|
      t.datetime :grouping_date
      t.integer :lead_request_users
      t.integer :lead_users
      t.integer :leads
      t.float   :leads_by_lead_users
      t.float   :unreconciled_publisher_lead_revenue
      t.integer :clickout_impressions
      t.integer :clickouts
      t.float   :clickthrough_rate
      t.float   :unreconciled_publisher_clickout_revenue
      t.float   :unreconciled_publisher_total_revenue
      t.string  :source_code
      t.string  :tracking_code
      t.integer :adult_lead_request_users
      t.integer :adult_lead_users
      t.integer :adult_leads
      t.integer :adult_leads_by_lead_users
      t.float   :adult_unreconciled_publisher_lead_revenue
      t.integer :adult_clickouts
      t.integer :adult_clickout_revenue
      t.integer :hs_lead_request_users
      t.integer :hs_lead_users
      t.integer :hs_leads
      t.integer :hs_leads_by_lead_users
      t.float   :hs_unreconciled_published_clickout_revenue
      t.integer :hs_clickouts
      t.float   :hs_clickout_revenue
    end
  end
end
