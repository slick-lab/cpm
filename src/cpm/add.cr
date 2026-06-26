require "path"
require "yaml"

module Cli
  class Add
    def run(args : Array(String))
      package = args[0]? || ""
      if package.empty?
        puts "Usage: cpm add <package name>"
        exit 1
      end
      check_package(package)
    end

    def check_package(package : String)
      cache_file = Path.home / ".cpm" / "cache.txt"

      if File.exists?(cache_file)
        File.each_line(cache_file) do |line|
          name = line.split('\t')[0]?
          url = line.split('\t')[1]?.try(&.strip)
          if name == package && url
            write_to_shard(package, url)
            return # ← found it, stop!
          end
        end
      end

      # Not found in cache → search
      search_package(package)
    end

    def search_package(package : String)
      result = Cli::Search.new.run([package, "--auto"])

      if result
        write_to_shard(result.name, result.url)
      else
        puts "Package '#{package}' not found."
        exit 1
      end
    end

    def write_to_shard(name : String, url : String)
      unless File.exists?("shard.yml")
        puts "No shard.yml found. Run 'cpm init' first."
        exit 1
      end
      clean_url = url.split("github.com/")[1]

      shard = YAML.parse(File.read("shard.yml")).as_h

      deps = shard["dependencies"]?.try(&.as_h?) || {} of YAML::Any => YAML::Any
      dep = {} of YAML::Any => YAML::Any
      dep[YAML::Any.new("github")] = YAML::Any.new(clean_url)
      deps[YAML::Any.new(name)] = YAML::Any.new(dep)
      shard[YAML::Any.new("dependencies")] = YAML::Any.new(deps)

      File.write("shard.yml", shard.to_yaml)
      puts "Added #{name} to shard.yml"
    end
  end
end
