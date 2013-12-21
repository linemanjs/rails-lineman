module Rake
  TaskManager.class_eval do
    def __lineman_rails__alias_task(fq_name)
      new_name = "#{fq_name}:original"
      @tasks[new_name] = @tasks.delete(fq_name)
    end
  end
end
