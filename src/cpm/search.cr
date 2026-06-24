require "http/client"
require "json"

module Cli
  class Search
    GITHUB_API = "https://api.github.com/search/repositories"

    def run(args : Array(String))
      query = args[0]? || ""
      if query.empty?
        puts "Usage: cpm search <package-name>"
        exit 1
      end

      auto = args.includes?("--auto")
      results = search_github(query)

      if results.empty?
        puts "No results found."
        exit 1
      end

      if auto
        pick = results[0]
        cache_result(pick)
        puts "Added #{pick.name} to cache."
      else
        results.each_with_index do |result, i|
          puts "#{i + 1}. #{result.full_name} ★ #{result.stars}"
          puts "   #{result.description}"
          puts ""
        end

        print "Pick one (1-#{results.size}): "
        choice = gets.try(&.to_i) || 0

        if choice < 1 || choice > results.size
          puts "Invalid choice."
          exit 1
        end

        pick = results[choice - 1]
        cache_result(pick)
        puts "Added #{pick.name} to cache."
      end
    end

    private def search_github(query : String) : Array(RepoResult)
      url = "#{GITHUB_API}?q=#{URI.encode_path(query)}+language:crystal&sort=stars&per_page=5"
      
      response = HTTP::Client.get(url, headers: HTTP::Headers{
        "User-Agent" => "cpm"
      })

      data = JSON.parse(response.body)
      items = data["items"]?

      return [] of RepoResult unless items

      items.as_a.map do |item|
        RepoResult.new(
          name: item["name"].as_s,
          full_name: item["full_name"].as_s,
          url: item["html_url"].as_s,
          description: item["description"]?.try(&.as_s) || "",
          stars: item["stargazers_count"].as_i
        )
      end
    end

    private def cache_result(result : RepoResult)
      cache_file = Path.home / ".cpm" / "cache.txt"
      Dir.mkdir_p(Path.home / ".cpm")

      File.open(cache_file, "a") do |file|
        file.puts "#{result.name}\t#{result.url}"
      end
    end
  end

  struct RepoResult
    property name : String
    property full_name : String
    property url : String
    property description : String
    property stars : Int32

    def initialize(@name, @full_name, @url, @description, @stars)
    end
  end
end
