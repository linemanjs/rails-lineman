module RailsLineman
  class Railtie < Rails::Railtie
    config.rails_lineman = ActiveSupport::OrderedOptions.new

    config.rails_lineman.lineman_project_location = ENV['LINEMAN_PROJECT_LOCATION']
    config.rails_lineman.lineman_project_namespace = nil
    config.rails_lineman.lineman_assets = ENV['LINEMAN_ASSETS'] || [:js, :css]
    config.rails_lineman.lineman_pages = ENV['LINEMAN_PAGES'] || [:index]
    config.rails_lineman.remove_lineman_assets_after_asset_pipeline_precompilation = false
    config.rails_lineman.skip_build = false
    config.rails_lineman.deployment_method = :assets # :copy_files_to_public_folder or :assets
    config.rails_lineman.tmp_dir = File.join("tmp", "rails_lineman")
    config.rails_lineman.asset_paths = [ config.rails_lineman.tmp_dir ]

    rake_tasks do
      file = if(config.rails_lineman.deployment_method == :copy_files_to_public_folder)
        File.join(File.dirname(__FILE__), '..', 'tasks', 'deploy_frontend.rake')
      elsif(config.rails_lineman.deployment_method == :assets)
        File.join(File.dirname(__FILE__), '..', 'tasks', 'assets_precompile.rake')
      end
      load(file)
    end

    initializer "rails_lineman.add_asset_paths" do
      if(config.rails_lineman.deployment_method == :assets)
        Rails.application.config.assets.paths |= config.rails_lineman.asset_paths.map { |path| Rails.root.join(path) }
      end
    end

    config.before_initialize do
      require 'rails_lineman/meta_lineman_doer'
        config = Rails.application.config.rails_lineman

      if(config.deployment_method == :copy_files_to_public_folder && Rails.env == 'production' && !config.skip_build)
        if config.lineman_project_location.present?
          lineman_doer = RailsLineman::MetaLinemanDoer.new(config)
          lineman_doer.copy_files
        else
          puts "WARNING: No Lineman project location was set (see: `config.rails_lineman.lineman_project_location`). Skipping Lineman build"
        end
      end

    end

  end
end