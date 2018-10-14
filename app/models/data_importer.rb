require 'csv'
require 'chronic'
class DataImporter
  def self.import_ce_data
    file_names = ['ce_data_2017.csv' ,'ce_data_2018.csv' ]
    file_names.each do |file_name|
      CSV.foreach("db/files/#{file_name}", headers: true ).each do |row|
          ce = Ce.new
          ce.grouping_date = Chronic.parse(row[0])
          ce.lead_request_users = row[1].to_i
          ce.lead_users = row[2].to_i
          ce.leads = row[3].to_i
          ce.leads_by_lead_users = row[4].to_f
          ce.unreconciled_publisher_lead_revenue = row[5].to_f
          ce.clickout_impressions = row[6].to_i
          ce.clickouts = row[7].to_i
          ce.clickthrough_rate = row[8].to_f
          ce.unreconciled_publisher_clickout_revenue = row[9].to_f
          ce.unreconciled_publisher_total_revenue = row[10].to_f
          ce.source_code = row[11]
          ce.tracking_code = row[12]
          ce.adult_lead_request_users = row[13].to_i
          ce.adult_lead_users = row[14].to_i
          ce.adult_leads = row[15].to_i
          ce.adult_leads_by_lead_users = row[16].to_f
          ce.adult_unreconciled_publisher_lead_revenue = row[17].to_f
          ce.adult_clickouts = row[18].to_i
          ce.adult_clickout_revenue = row[19].to_i
          ce.hs_lead_request_users = row[20].to_i
          ce.hs_lead_users = row[21].to_f
          ce.hs_leads = row[22].to_i
          ce.hs_leads_by_lead_users = row[23].to_f
          ce.hs_unreconciled_published_clickout_revenue = row[24].to_f
          ce.hs_clickouts = row[25].to_i
          ce.hs_clickout_revenue = row[26].to_f
          ce.save
       end
    end
  end

  def self.import_pusuit
    file_names = ['pursuit_metrics.csv' ]
    file_names.each do |file_name|
      CSV.foreach("db/files/#{file_name}", headers: true ).each do |row|
         pm = PursuitMetric.new
         pm.date = Chronic.parse(row[0])
         pm.account_id = row[1]
         pm.custom = row[2]
         pm.earnings = row[3].to_f
         pm.save
       end
    end
  end

  def self.import_pursuit_merged
    file_names = ['pursuit_merged.csv' ]
    file_names.each do |file_name|
      CSV.foreach("/app/db/files/#{file_name}", headers: true ).each do |row|
       Pum.import_csv_row(row)
       next
       pum = Pum.new
       pum.date                       = Chronic.parse(row[0])
       pum.label                      = row[1]
       pum.account_id                 = row[2]
       pum.campaign_id                = row[3]
       pum.ad_group_id                = row[4]
       pum.keyword_id                 = row[5]
       pum.publisher                  = row[6]
       pum.account_name               = row[7]
       pum.campaign_name              = row[8]
       pum.ad_group_name              = row[9]
       pum.keyword                    = row[10]
       pum.focus_word                 = row[11]
       pum.industry                   = row[12]
       pum.device_type                = row[13]
       pum.impressions                = row[14].to_i
       pum.cost_per_click             = row[15].to_f
       pum.cost                       = row[16].to_f
       pum.click_count                = row[17].to_i
       pum.total_unreconciled_revenue = row[18].to_f
       pum.total_clickout_revenue     = row[19].to_f
       pum.leads                      = row[20].to_i
       pum.clickouts                  = row[21].to_i
       pum.lead_users                 = row[22].to_i
       pum.lead_request_users         = row[24].to_i
       pum.save
     end
    end
  end

end
