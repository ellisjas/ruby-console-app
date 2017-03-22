#!/usr/bin/ruby

require 'thor'
require 'json'

class ListTrends < Thor

  desc "list_trends json", "list out trends from JSON file"
  option :api_key, :aliases => "--api-key", :type => :string, :required => true
  option :format, :type => :string, :desc => "one line format"
  option :no_country_code, :aliases => "--no-country-code", :desc => "remove country code", :type => :boolean
  def list_trends(keyword=nil)

    json = File.read('trends_available.json')
    trends_hash = JSON.parse(json)
    re = /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/
    keyword = keyword.to_s.downcase

    if re.match(options[:api_key])

      trends_hash.each do |trend|
        if trend["country"].downcase.include?(keyword)
          if options[:format]
            output = trend.values[0..2]
            output.delete_at(1) if options[:no_country_code]
            puts output.join(" ")
          else
            # Complete output
            trend.each do |k, v|
              if v.is_a?(Hash)
                v.each do |i, j| puts "Trend location type #{i}: #{j}" end
              else
                puts "Trend #{k}: #{v}"
              end
            end # trend.each do
            puts ""
          end # if options[:format]
        end # if trend["country"]
      end # trends_hash.each
      
    else
      puts "Invalid API Key, operation abort..."
    end # if re.match

  end # list_trends
end

ListTrends.start(ARGV)
