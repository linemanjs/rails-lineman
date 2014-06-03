module RailsLineman
  class Asset
    def initialize(config, descriptor)
      @descriptor = descriptor.strip
      @source = File.join(config.lineman_project_location, "dist", descriptor, ".")
      @destination = destination
    end

    def destination
      if is_precompilable?
        Rails.root.join(File.join("tmp", "rails_lineman", "lineman"))
      else
        Rails.root.join(File.join("public", "assets", @descriptor))
      end
    end

    def ensure_directories
      [@source, @destination].each do |path|
        FileUtils.mkdir_p(path)
      end
    end

    def copy
      FileUtils.cp_r(@source, @destination)
    end

    def add_if_precompilable
      return unless is_precompilable?
      Rails.application.config.assets.precompile += Dir.glob("#{@destination}/**/*.#{@descriptor}")
    end

    def is_precompilable?
      ["js", "css"].include?(@descriptor)
    end

    def delete
      FileUtils.rm_rf(@destination)
    end
  end
end
