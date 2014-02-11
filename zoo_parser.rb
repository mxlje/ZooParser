require "nokogiri"
require "time"
require "json"

class ZooParser

  def initialize(filepath)
    @bookmarks = []

    begin
      export_file = File.read(filepath)
    rescue Errno::ENOENT => e
      raise "Looks like you misspelled the path to your export file. #{e}"
    end

    doc = Nokogiri::HTML(export_file)
    bookmarks = []

    doc.css("dl dt").lazy.each_with_index do |dt, i|
      link = dt.children.css("a").first

      bm = {
        id: i+1,
        date_added:   Time.at(link.get_attribute(:add_date).to_i).utc,
        origin:       link.get_attribute(:href),
        referer:      link.get_attribute(:referer),
        s3_url:       nil,
        tags:         [],
        title:        link.text,
        type:         link.get_attribute(:type)
      }

      large_s3_url = link.get_attribute(:image)
      bm[:s3_url] = large_s3_url ? large_s3_url.sub("s.jpg", "l.jpg") : nil

      tags = link.get_attribute(:tags)
      bm[:tags] = tags ? tags.split(",") : []

      @bookmarks << bm
    end
  end

  def to_json
    File.open("zoo_export_#{Time.now.to_i}.json", "w") do |json|
      json.write "["
      
      @bookmarks.each_with_index do |b, i|
        print "."
        json.write b.to_json
        json.write "," unless i == @bookmarks.size - 1
      end

      json.write "]"
    end
  end

  def count
    @bookmarks.count
  end
end

if ARGV.empty?
  puts "Usage: ruby zoo_parser.rb export_file.html"
  exit
end

export_file = ARGV.first

@parser = ZooParser.new(export_file)

puts "Exporting #{@parser.count} bookmarks, hang tight."
@parser.to_json
puts "done."