module RailsLineman
  class Page
    def initialize(config, descriptor)
      @descriptor = "#{descriptor.strip}.html"
      @source = File.join(config.lineman_project_location, "dist", @descriptor)
      @destination = determine_destination(config)
    end

    def ensure_directories
      [@source, @destination].each do |path|
        FileUtils.mkdir_p(path)
      end
    end

    def copy
      FileUtils.cp(@source, @destination)
    end

    def delete
      FileUtils.rm_rf(@destination)
    end

  private

    def determine_destination(config)
      if config.deployment_method == :copy_files_to_public_folder
        Rails.root.join(File.join(*["public", @descriptor].compact))
      end
    end

  end
end