#shamelessly cribbed from http://metaskills.net/2010/05/26/the-alias_method_chain-of-rake-override-rake-task/

require 'rails_lineman/ext/rake/task_manager'

module RailsLineman
  module TaskHelpers
    def self.alias_task(fq_name)
      Rake.application.__lineman_rails__alias_task(fq_name)
    end

    def self.override_task(*args, &block)
      name, params, deps = Rake.application.resolve_args(args.dup)
      scope = Rake.application.instance_variable_get(:@scope).dup
      fq_name = if scope.respond_to?(:push)
        scope.push(name).join(':')
      else
        scope.to_a.reverse.push(name).join(':')
      end
      self.alias_task(fq_name)
      Rake::Task.define_task(*args, &block)
    end
  end
end

