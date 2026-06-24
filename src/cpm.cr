require "./cpm/init"
require "./cpm/search"
require "./cpm/add"
require "./cpm/remove"

module Cli
  case ARGV[0]?
  when "init"
    Init.new.run(ARGV[1..-1])
  when "search"
    Search.new.run(ARGV[1..-1])
  when "add"
    Add.new.run(ARGV[1..-1])
  when "remove"
    Remove.new.run(ARGV[1..-1])
  else
    puts "cpm - Crystal Package Manager"
    puts ""
    puts "Usage: cpm <command> [options]"
    puts ""
    puts "Commands:"
    puts "  init              Initialize a new project"
    puts "  init --cache      Initialize with global cache"
    puts "  search <name>     Search for a package"
    puts "  search <name> --auto  Auto-pick top result"
    puts "  add <name>        Add a dependency to shard.yml"
    puts "  remove <name>     Remove a dependency from shard.yml"
    puts ""
    puts "After add/remove, run 'shards install' or 'shards prune'"
  end
end
