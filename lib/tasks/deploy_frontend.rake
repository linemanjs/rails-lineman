require 'rails_lineman/task_helpers'

require 'rails_lineman/meta_lineman_doer'

namespace :deploy do
  desc 'Add frontend dist files to rails public folder'
  Rake::Task.define_task :frontend => :environment do
    begin
      config = Rails.application.config.rails_lineman
      if config.lineman_project_location.present?
        lineman_doer = RailsLineman::MetaLinemanDoer.new(config)
        lineman_doer.copy_files
      else
        puts "WARNING: No Lineman project location was set (see: `config.rails_lineman.lineman_project_location`). Skipping Lineman build"
      end

    ensure
      lineman_doer.try(:destroy_assets)
    end
  end
end
