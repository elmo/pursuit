require 'csv'
class Pum < ApplicationRecord
  before_validation :compute_id
  validates_uniqueness_of :computed_id

  def self.process_google_drive
    download_export_files_from_google_drive
    save_csv_files_to_database
  end

  def self.files
   {
    '1PSwvFyXFHaar9L6g7E4x0uDHc7YYGtPafar__Q37xvg'  =>  'bing.csv',
    '1xgshHf7QVqkMb8ko73W5SORaarwTP9kEvYEco7C3j6w'  =>  'google.csv'
   }
  end

  def self.download_export_files_from_google_drive
    google_drive = GoogleDrive.new
    files.each do |file_id, name|
      google_drive.download_file(file_id: file_id, name: name)
    end
  end

  def self.save_csv_files_to_database
    files.each do |file_id, name|
       CSV.foreach("#{name}", headers: true ).each do |row|
         Pum.save_csv_row(row: row)
      end
      File.unlink(name)
    end
  end

  def self.atts
    [
     "date", "account_name", "account_id", "campaign_name", "campaign_id", "ad_group_name", "ad_group_id",
     "device_type", "keyword", "keyword_id", "match_type", "keyword_status", "final_url", "final_mobile_url",
     "click_count", "conversions"
    ]
  end

 def self.save_csv_row(row:)
     pum = Pum.new
     pum.date                       = Chronic.parse(row[0])
     pum.account_name               = row[1]
     pum.account_id                 = row[2]
     pum.campaign_name              = row[3]
     pum.campaign_id                = row[4]
     pum.ad_group_name              = row[5]
     pum.ad_group_id                = row[6]
     pum.device_type = pum.campaign_name.match(/\(.*\)/)[0].gsub(/\W/, '')
     pum.keyword                    = row[8]
     pum.keyword_id                 = row[9]
     pum.match_type                 = row[10]
     pum.keyword_status             = row[11]
     pum.final_url                  = row[12]
     pum.final_mobile_url           = row[13]
     pum.click_count                = row[14].to_i
     pum.cost                       = row[15].to_f
     pum.conversions                = row[16].to_i

     pum.device_type                = "Desktop" if pum.device_type == "Tablets with Full Browsers" or  pum.device_type == "Computers"
     begin
       pum.save!
     rescue
     end
  end

  def self.send_report_to_google_drive(pums)
     timestamp = Time.zone.now.strftime("%Y-%m-%d-%H-%M")
     file_name = "#{timestamp}-export.csv"
     CSV.open(file_name, "wb") do |csv|
       csv << atts
       pums.each do |pum|
         csv << atts.map{ |attr| pum.send(attr) }
       end
     end
    google_drive = GoogleDrive.new
    google_drive.save_file_to_drive(file_name, file_name)
    File.unlink(file_name)
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << atts
        all.each do |pum|
        csv << atts.map{ |attr| pum.send(attr)  }
      end
    end
  end

 def self.import_csv_row(row)
   pum = Pum.new
   pum.date = Chronic.parse(row[0])
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
   pum.device_type = pum.campaign.match(/\(.*\)/)[0].gsub(/\W/, '')
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

  def compound_key
    keyword_id + ad_group_id + campaign_id + date.strftime("%Y-%m-%d")
  end

  def compute_id
    self.computed_id = Digest::MD5.hexdigest(compound_key)
  end

  private

end
