require 'csv'
require 'tempfile'

class Ce < ApplicationRecord
 SFTP_HOST = 'campusexplorer.brickftp.com'
 SFTP_USERNAME = 'criminaljusticepursuit'
 SFTP_PASSWORD = 'UlRh1Lz&iuq4'

  def self.save_last_entry_data
    read_last_entry_data.each {|row| save_row(row)}
  end

  def self.save_row(row)
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

  def self.cols
   [:grouping_date, :lead_request_users, :lead_users, :leads, :leads_by_lead_users, :unreconciled_publisher_lead_revenue, :clickout_impressions, :clickouts, :clickthrough_rate, :unreconciled_publisher_clickout_revenue, :unreconciled_publisher_total_revenue, :source_code, :tracking_code, :adult_lead_request_users, :adult_lead_users, :adult_leads, :adult_leads_by_lead_users, :adult_unreconciled_publisher_lead_revenue, :adult_clickouts, :adult_clickout_revenue, :hs_lead_request_users, :hs_lead_users, :hs_leads, :hs_leads_by_lead_users, :hs_unreconciled_published_clickout_revenue, :hs_clickouts, :hs_clickout_revenue]
  end

end
