desc "This task is called by the Heroku scheduler add-on"
task :save_last_campus_explorer_file => :environment do
  puts "save last Ce entry to google drive..."
  Ce.save_last_entry_to_google_drive
end
