namespace :db do
  namespace :test do 
    desc "Cleans the test db"
    task clean: :environment do 
      if Rails.env.test?
        # +pre_count+ checks for existing rows before truncation
        DatabaseCleaner.strategy = :truncation, { :pre_count => true }
        DatabaseCleaner.clean
      else
        system("bundle exec rake db:test:clean RAILS_ENV='test'")
        fail if $?.exitstatus.nonzero?
      end
    end
  end
end
