#!/usr/bin/env ruby

require 'rake'
require "json"
require 'fileutils'

require_relative "./vdf"

patches = {
  'dota/resource/dota_english.txt' => {
    %("Notes:\\n\\nHas a 0.35 seconds transformation time."\r\nYou can dodge projectiles and abilities while transforming.) =>
      %("Notes:\\n\\nHas a 0.35 seconds transformation time.\r\nYou can dodge projectiles and abilities while transforming."),
  }
}

%w[
  dota/resource/{items,dota}_*.txt
  dota_pak01/scripts/items/items_game.txt
  dota_pak01/scripts/regions.txt
].each do |glob|
  Dir.glob glob do |source|
    json_name = File.basename(source, '.txt') + ".json"
    directory = File.dirname(source)
    dest_directory = File.join('json', directory)
    dest = File.join(dest_directory, json_name)

    FileUtils.mkdir_p dest_directory

    puts "Converting #{source} to #{dest}..."

    begin
      txt = File.read(source)
      [*patches[source]].each{|k, v| warn "patch failed: #{k} => #{v}" unless txt.sub!(k, v) }
      vdf = VDF.new(txt)
      res = JSON.pretty_generate(vdf.kvs)

      File.open(dest, "w") {|f| f.write(res) }
    rescue => ex
      puts "Error: #{ex}"
    end

    sh 'git', 'add', dest
  end
end
