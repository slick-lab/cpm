require "path"
require "yaml"

module Cli
  class Remove
    def run(args : Array(String))
      package = args[0]? || ""
      if package.empty?
        puts "Usage: cpm remove <package name>"
        exit 1
      end

      unless File.exists?("shard.yml")
        puts "No shard.yml found."
        exit 1
      end

      shard = YAML.parse(File.read("shard.yml")).as_h
      deps = shard["dependencies"]?.try(&.as_h?)

      unless deps
        puts "No dependencies to remove."
        exit 1
      end

      unless deps.has_key?(YAML::Any.new(package))
        puts "'#{package}' is not in shard.yml."
        exit 1
      end

      deps.delete(YAML::Any.new(package))
      shard[YAML::Any.new("dependencies")] = YAML::Any.new(deps)

      File.write("shard.yml", shard.to_yaml)
      puts "Removed #{package} from shard.yml."
      puts "Run 'shards prune' to clean up installed files."
    end
  end
end
