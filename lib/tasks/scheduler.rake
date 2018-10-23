desc "Download last CE file and upload it to Google Drive"
task :save_last_campus_explorer_file => :environment do
  puts "save last Ce entry to google drive..."
  Ce.save_last_entry_to_google_drive
end

desc "Import Example file"
task :import_pursuit_merged => :environment do
  puts "saving local sample file from sample data"
  DataImporter.import_pursuit_merged
end

desc "Import Bing Sample"
task :import_pursuit_bing => :environment do
  puts "saving local sample file from sample data"
  DataImporter.import_pursuit_bing
end
