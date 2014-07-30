require 'rails_lineman/task_helpers'

require 'rails_lineman/meta_lineman_doer'

if Rails::VERSION::MAJOR == 3

  namespace :assets do
    desc 'Compile all the assets named in config.assets.precompile (Wrapped by rails-lineman)'
    namespace :precompile do
      RailsLineman::TaskHelpers.override_task :nondigest => :environment do
        begin
          config = Rails.application.config.rails_lineman
          if config.lineman_project_location.present?
            lineman_doer = RailsLineman::MetaLinemanDoer.new(config)
            lineman_doer.precompile_assets
          else
            puts "WARNING: No Lineman project location was set (see: `config.rails_lineman.lineman_project_location`). Skipping Lineman build"
          end
          Rake::Task["assets:precompile:nondigest:original"].invoke
        ensure
          lineman_doer.try(:destroy_assets)
        end
      end
      RailsLineman::TaskHelpers.override_task :all => :environment do
        begin
          config = Rails.application.config.rails_lineman
          if config.lineman_project_location.present?
            lineman_doer = RailsLineman::MetaLinemanDoer.new(config)
            lineman_doer.precompile_assets
          else
            puts "WARNING: No Lineman project location was set (see: `config.rails_lineman.lineman_project_location`). Skipping Lineman build"
          end

          Rake::Task["assets:precompile:all:original"].invoke
        ensure
          lineman_doer.try(:destroy_assets)
        end
      end
    end
  end

else

  namespace :assets do
    desc 'Compile all the assets named in config.assets.precompile (Wrapped by rails-lineman)'
    RailsLineman::TaskHelpers.override_task :precompile => :environment do
      begin
        config = Rails.application.config.rails_lineman
        if config.lineman_project_location.present?
          lineman_doer = RailsLineman::MetaLinemanDoer.new(config)
          lineman_doer.precompile_assets
        else
          puts "WARNING: No Lineman project location was set (see: `config.rails_lineman.lineman_project_location`). Skipping Lineman build"
        end

        Rake::Task["assets:precompile:original"].execute
      ensure
        lineman_doer.try(:destroy_assets)
      end
    end
  end
end
