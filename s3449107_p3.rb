#!/usr/bin/ruby

require 'thor'
require 'json'

class ListTrends < Thor

  VALID_API_KEY_RE = /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/

  desc   'list_trends json', 'list out trends from JSON file'
  option :api_key, aliases: '--api-key', type: :string, required: true
  option :format, type: :string, desc: 'one line format'
  option :no_country_code, aliases: '--no-country-code', desc: 'remove country code', type: :boolean

  def list_trends(keyword=nil)

    # Check your options before reading the file
    if !VALID_API_KEY_RE.match(options[:api_key])
      puts "Invalid API Key, operation abort..."
      exit(255)
    end

    json        = File.read('trends_available.json')
    trends_hash = JSON.parse(json)
    keyword     = keyword.to_s.downcase

    trends_hash.each do |trend|
      process_trend(trend, keyword)
    end
  end

  private

  def process_trend(trend, keyword)
    return unless trend["country"].downcase.include?(keyword)

    if options[:format] == "oneline"
      output_formatted_trend(trend)
    else
      output_complete_trend(trend)
    end
  end

  def output_formatted_trend(trend)
    output = trend.values[0..2]
    output.delete_at(1) if options[:no_country_code]
    puts output.join(' ')
  end

  def output_complete_trend(trend)
    trend.each do |k, v|
      if v.is_a?(Hash)
        v.each do |i, j| puts "Trend location type #{i}: #{j}" end
      else
        puts "Trend #{k}: #{v}"
      end
    end
    puts ''
  end

end

ListTrends.start(ARGV)
