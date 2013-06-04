desc "This task is called by the Heroku scheduler add-on"
task :backup => :environment do
  puts "backing up databse..."
  HerokuS3Backup.backup
  puts "done."
end