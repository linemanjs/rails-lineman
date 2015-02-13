require 'rails_lineman/lineman_doer'

module RailsLineman
  class MetaLinemanDoer
    def initialize(config)
      @lineman_doers = options_per_project(config).map {|c| LinemanDoer.new(c) }
    end

    def precompile_assets
      @lineman_doers.map(&:precompile_assets)
    end

    def copy_files
      @lineman_doers.map(&:copy_files)
    end

    def destroy_assets
      @lineman_doers.map(&:destroy_assets)
    end

    private

    def options_per_project(config)
      return [config] unless config.lineman_project_location.respond_to?(:keys)
      config.lineman_project_location.map do |(name, location)|
        config.dup.tap do |single_project_config|
          single_project_config.lineman_project_location = location
          single_project_config.lineman_project_namespace = name.to_s
        end
      end
    end
  end
end
