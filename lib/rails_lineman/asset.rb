module RailsLineman
  class Asset
    def initialize(config, descriptor)
      @descriptor = descriptor.strip
      @source = File.join(config.lineman_project_location, "dist", descriptor, ".")
      @destination = determine_destination(config.lineman_project_namespace)
    end

    def ensure_directories
      [@source, @destination].each do |path|
        FileUtils.mkdir_p(path)
      end
    end

    def add_if_precompilable
      return unless is_precompilable?
      Rails.application.config.assets.precompile += Dir.glob("#{@destination}/**/*.#{@descriptor}")
    end

    def copy
      FileUtils.cp_r(@source, @destination)
    end

    def delete
      FileUtils.rm_rf(@destination)
    end

  private

    def determine_destination(namespace)
      if is_precompilable?
        Rails.root.join(File.join(*["tmp", "rails_lineman", "lineman", namespace].compact))
      else
        Rails.root.join(File.join(*["public", "assets", namespace, @descriptor].compact))
      end
    end

    def is_precompilable?
      ["js", "css"].include?(@descriptor)
    end
  end
end
