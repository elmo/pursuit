require 'csv'
require 'tempfile'

class Ce < ApplicationRecord
 SFTP_HOST = 'campusexplorer.brickftp.com'
 SFTP_USERNAME = 'criminaljusticepursuit'
 SFTP_PASSWORD = 'UlRh1Lz&iuq4'

  after_validation :parse_source_code_field
  after_validation :compute_id

  def self.save_last_entry_data
    read_last_entry_data.each {|row| save_row(row)}
  end

  def self.save_row(r)
    row = r.split(',')
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

  def self.save_csv_to_google_drive
    to_csv
    google_drive = GoogleDrive.new
    google_drive.save_file_to_drive(file_name, file_name)
  end

  def self.file_name
    "campus-explorer-#{Date.today.strftime("%Y-%m-%d")}.csv"
  end

  def self.to_csv
    CSV.open(file_name, 'wb') do |csv|
      Ce.all.each do |ce|
        row = []
        Ce.cols.each { |col| row << ce.send(col) }
        csv << row
      end
    end
  end

  def self.read_last_entry_data
    lines = []
    last_entry_data.split(/\n/).each_with_index do |line,i|
      next if i == 0
       lines << line
    end
    lines
  end

  def self.save_last_entry_to_google_drive
    file = File.open(file_name, 'w')
    file.write last_entry_data
    file.close
    google_drive = GoogleDrive.new
    google_drive.save_file_to_drive(file_name, file_name)
  end

  def self.last_entry_data
    sftp.download(remote_path: '/' + last_entry )
  end

  def self.last_entry
    sftp.read_remote_directory(directory_path: '/').last
  end

  def self.sftp
    FalconSftp.new(SFTP_HOST,SFTP_USERNAME,SFTP_PASSWORD)
  end

  def parse_source_code_field
    a = self.source_code.split('_')
    return if a.size < 3
    self.campaign_id = a[2].gsub('cp-', '')
    self.adgroup_id = a[3].gsub('ag-', '')
    self.keyword_id = a[5].gsub('kw-', '') if a[5].present?
    self.page_variation_1 = a[6].gsub('p1var-', '') if a[6].present?
    self.page_variation_2 = a[7].gsub('p2var-', '') if a[7].present?
    self.publisher = ( a[1] == 'pb-b1') ? 'bing' : 'google'
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << cols
        all.each do |ce|
        csv << cols.map{ |attr| ce.send(attr)  }
      end
    end
  end

  def self.cols
   [:computed_id, :publisher, :grouping_date, :campaign_id , :adgroup_id, :keyword_id, :page_variation_1,
    :page_variation_2, :lead_request_users, :lead_users, :leads, :leads_by_lead_users,
    :unreconciled_publisher_lead_revenue, :clickout_impressions, :clickouts, :clickthrough_rate,
    :unreconciled_publisher_clickout_revenue, :unreconciled_publisher_total_revenue, :source_code, :tracking_code,
    :adult_lead_request_users, :adult_lead_users, :adult_leads, :adult_leads_by_lead_users,
    :adult_unreconciled_publisher_lead_revenue, :adult_clickouts, :adult_clickout_revenue, :hs_lead_request_users,
    :hs_lead_users, :hs_leads, :hs_leads_by_lead_users, :hs_unreconciled_published_clickout_revenue, :hs_clickouts, :hs_clickout_revenue
   ]
  end

  def compound_key
    return '' if keyword_id.blank?
    keyword_id + adgroup_id + campaign_id + grouping_date.strftime("%Y-%m-%d")
  end

  def compute_id
    self.computed_id = Digest::MD5.hexdigest(compound_key)
  end

end
