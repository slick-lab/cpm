
  class Init
    def init
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
