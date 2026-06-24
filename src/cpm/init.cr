require "path"
module Cli
  class Init
    def run(args : Array(String))
      i = 0
      while i < args.size
      case args[i]
      when "--cache"
       turn_cache
      else
       init_project
     end
   end 
   def turn_cache
     cache_dir = Path.home / ".cpm"
     Dir.mkdir_p(cache_dir)
     File.write(cache_dir / "cache.txt", "")
     puts "created cache.."
     init_project
  end

  def init_project
    process = Process.run(
        "shards",
        args: [init],
        output: Process::Redirect::Inherit
        error: Process::Redirect::Inherit
      )
      if process.exit_code == 0
       puts "Done."
     else
      puts "failed with #{process.exit_code}"
      exit 1 
     end
   end
 end
end
