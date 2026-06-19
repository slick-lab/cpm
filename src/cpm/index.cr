# index.cr
require "json"
require "http/client"

record SearchResult, name : String, url : String, source : String, description : String?

class PackageIndex
  GITHUB_API = "https://api.github.com/search/repositories?q=language:crystal"
  GITLAB_API = "https://gitlab.com/api/v4/projects?search="
  SHARDS_INFO = "https://shards.info/api/v1/shards"

  def search(query : String) : SearchResult?
    search_github(query) || search_gitlab(query) || search_shards_info(query)
  end

  private def search_github(query : String) : SearchResult?
    url = "#{GITHUB_API}&q=#{URI.encode_www_form(query)}"
    
    response = HTTP::Client.get(url, headers: HTTP::Headers{"User-Agent" => "cpm/0.1.0"})
    return nil unless response.status_code == 200
    
    data = JSON.parse(response.body)
    items = data["items"].as_a
    return nil if items.empty?
    
    first = items[0]
    SearchResult.new(
      first["full_name"].as_s,
      first["html_url"].as_s,
      "GitHub",
      first["description"]?.try &.as_s
    )
  rescue
    nil
  end

  private def search_gitlab(query : String) : SearchResult?
    url = "#{GITLAB_API}#{URI.encode_www_form(query)}"
    
    response = HTTP::Client.get(url)
    return nil unless response.status_code == 200
    
    data = JSON.parse(response.body)
    projects = data.as_a.select do |p|
      p["description"]?.try &.as_s?.try &.downcase.includes?("crystal") ||
      p["tag_list"]?.try &.as_a.try &.any? { |t| t.as_s.downcase == "crystal" }
    end
    return nil if projects.empty?
    
    first = projects[0]
    SearchResult.new(
      first["path_with_namespace"].as_s,
      first["web_url"].as_s,
      "GitLab",
      first["description"]?.try &.as_s
    )
  rescue
    nil
  end

  private def search_shards_info(query : String) : SearchResult?
    url = "#{SHARDS_INFO}?query=#{URI.encode_www_form(query)}"
    
    response = HTTP::Client.get(url)
    return nil unless response.status_code == 200
    
    data = JSON.parse(response.body)
    return nil if data.as_a.empty?
    
    first = data.as_a[0]
    SearchResult.new(
      first["name"].as_s,
      first["repository"].as_s,
      "shards.info",
      first["description"]?.try &.as_s
    )
  rescue
    nil
  end
end
