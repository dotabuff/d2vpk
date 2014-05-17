#!/usr/bin/env ruby

require 'rake'
require "json"
require 'fileutils'

require_relative "./vdf"

%w[
  dota/resource/items_*.txt
  dota_pak01/scripts/items/items_game.txt
  dota_pak01/scripts/regions.txt
].each do |glob|
  Dir.glob glob do |source|
    p source
    json_name = File.basename(source, '.txt') + ".json"
    directory = File.dirname(source)
    dest_directory = File.join('json', directory)
    dest = File.join(dest_directory, json_name)

    FileUtils.mkdir_p dest_directory

    puts "Converting #{source} to #{dest}..."

    begin
      txt = File.read(source)
      vdf = VDF.new(txt)
      res = JSON.pretty_generate(vdf.kvs)

      File.open(dest, "w") {|f| f.write(res) }
    rescue => ex
      puts "Error: #{ex}"
    end

    sh 'git', 'add', dest
  end
end
