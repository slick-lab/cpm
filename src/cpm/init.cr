require "path"

module Cli
  class Init
    def run(args : Array(String))
      if args.includes?("--cache")
        turn_cache
      else
        init_project
      end
    end

    def turn_cache
      cache_dir = Path.home / ".cpm"
      Dir.mkdir_p(cache_dir)
      File.write(cache_dir / "cache.txt", "")
      puts "Created cache."
      init_project
    end

    def init_project
      process = Process.run(
        "shards",
        args: ["init"],
        output: Process::Redirect::Inherit,
        error: Process::Redirect::Inherit
      )
      if process.exit_code == 0
        puts "Done."
      else
        puts "Failed with #{process.exit_code}"
        exit 1
      end
    end
  end
end
