require 'pathname'
require 'fileutils'

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
      if(is_precompilable?)
        Rails.application.config.assets.precompile +=
          Dir.glob("#{@destination}/**/*.#{@descriptor}")
      end
    end

    def is_precompilable?
      ["js", "css"].member? @descriptor
    end

    def delete
      FileUtils.rm_rf(@destination)
    end
  end

  class LinemanDoer
    def initialize(config)
      gather_assets(config)
      @lineman_project_location = config.lineman_project_location
      @tmp_dir = Rails.root.join(config.tmp_dir)
      @remove_lineman_assets_after_asset_pipeline_precompilation = config.remove_lineman_assets_after_asset_pipeline_precompilation
    end

    def gather_assets(config)
      @assets = config.lineman_assets.collect do |d|
        Asset.new(config, d.to_s)
      end
    end

    def build
      absolutify_lineman_path
      chdir @lineman_project_location do
        install_node_js_on_heroku
        run_npm_install
        run_lineman_build
        delete_node_js_from_heroku
      end
      ensure_directories_exist
      copy
      add_to_precompile_list
    end

    def destroy
      delete_some_assets_for_whatever_reason if @remove_lineman_assets_after_asset_pipeline_precompilation
      delete_tmp_dir
    end

  private

    def absolutify_lineman_path
      @lineman_project_location = Pathname.new(@lineman_project_location).realpath.to_s
    rescue => error
      puts <<-ERROR

        rails-lineman was not able to find your Lineman project at the path: `#{@lineman_project_location}`

        To configure the plugin to find your Lineman project, set one of these to its path:
          * An environment variable $LINEMAN_PROJECT_LOCATION
          * The config property `Rails.application.config.rails_lineman.lineman_project_location`

      ERROR
      raise error
    end

    def chdir(path)
      og_dir = Dir.pwd
      Dir.chdir(path)
      yield
      Dir.chdir(og_dir)
    end

    def install_node_js_on_heroku
      if heroku?
        puts "It looks like we're on heroku, so let's install Node.js"
        system <<-BASH
          node_version=$(curl --silent --get https://semver.io/node/resolve)
          node_url="http://s3pository.heroku.com/node/v$node_version/node-v$node_version-linux-x64.tar.gz"
          curl "$node_url" -s -o - | tar xzf - -C .
          mv node-v$node_version-linux-x64 heroku_node_install
          chmod +x heroku_node_install/bin/*
          export PATH="$PATH:$(pwd)/heroku_node_install/bin"
        BASH
        ENV['PATH'] += ":#{Dir.pwd}/heroku_node_install/bin"
      end
    end

    def heroku?
      ENV['DYNO'] && ENV['STACK']
    end

    def run_npm_install
      return if system "npm install"
      raise <<-ERROR

        rails-lineman failed while running `npm install` from the `#{@lineman_project_location}` directory.

        Make sure that you have Node.js installed on your system and that `npm` is on your PATH.

        You can download Node.js here: http://nodejs.org

      ERROR
    end

    def run_lineman_build
      return if system "lineman build"
      return if system "./node_modules/.bin/lineman build"

      raise <<-ERROR

        rails-lineman failed when trying to run `lineman build`.

        Attempted to execute `lineman` as if on your PATH, then directly from
        the npm binstub at `./node_modules/.bin/lineman`.

        Try again after installing lineman globally with `npm install -g lineman`

      ERROR
    end

    def delete_node_js_from_heroku
      system "rm -rf heroku_node_install" if heroku?
    end

    def ensure_directories_exist
      @assets.map(&:ensure_directories)
    end

    def copy
      @assets.map(&:copy)
    end

    def add_to_precompile_list
      @assets.map(&:add_if_precompilable)
    end

    def delete_some_assets_for_whatever_reason
      @assets.map(&:delete)
    end

    def delete_tmp_dir
      FileUtils.rm_rf(@tmp_dir)
    end

  end
end
