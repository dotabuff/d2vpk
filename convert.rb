#!/usr/bin/env ruby
require 'rake'
require "json"

require_relative "./vdf"

sh 'mkdir', '-p', 'json/dota/resource'

Dir.glob('dota/resource/items_*.txt') do |source|
  dest = "json/dota/resource/#{File.basename(source.gsub("txt", "json"))}"

  puts "Converting #{source} to #{dest}..."

  begin
    txt = File.read(source)
    vdf = VDF.new(txt)
    res = JSON.pretty_generate(vdf.kvs)

    File.open(dest, "w") {|f| f.write(res) }
  rescue => ex
    puts "Error: #{ex}"
  end

end

sh 'git', 'add', 'json/dota/resource/*.json'
