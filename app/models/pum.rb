require 'csv'
class Pum < ApplicationRecord


  def self.to_csv
    attributes = ["date", "label", "account_id", "campaign_id", "ad_group_id",
                  "keyword_id", "publisher", "account_name", "campaign_name",
                  "ad_group_name", "keyword", "focus_word", "industry", "device_type",
                  "impressions", "cost_per_click", "cost", "click_count",
                  "total_unreconciled_revenue", "total_clickout_revenue", "leads",
                  "clickouts", "lead_users", "lead_request_users"]
    CSV.generate(headers: true) do |csv|
      csv << attributes
        all.each do |pum|
        csv << attributes.map{ |attr| pum.send(attr)  }
      end
   end
 end

 def self.import_csv_row(row)
   pum = Pum.new
   pum.date= Chronic.parse(row[0])
   pum.label = row[1]
   pum.account_id = row[2]
   pum.campaign_id = row[3]
   pum.ad_group_id = row[4]
   pum.keyword_id = row[5]
   pum.publisher  = row[6]
   pum.account_name = row[7]
   pum.campaign_name = row[8]
   pum.ad_group_name = row[9]
   pum.keyword = row[10]
   pum.focus_word = row[11]
   pum.industry = row[12]
   pum.device_type = row[13]
   pum.impressions = row[14].to_i
   pum.cost_per_click = row[15].to_f
   pum.cost = row[16].to_f
   pum.click_count = row[17].to_i
   pum.total_unreconciled_revenue = row[18].to_f
   pum.total_clickout_revenue = row[19].to_f
   pum.leads = row[20].to_i
   pum.clickouts = row[21].to_i
   pum.lead_users = row[22].to_i
   pum.lead_request_users = row[24].to_i
   pum.save
  end
end
