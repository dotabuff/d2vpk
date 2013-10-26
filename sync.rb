#!/usr/bin/env ruby
require 'rake'

dota = "#{ENV["HOME"]}/.steam/steam/SteamApps/common/dota\ 2\ beta"
ignore = %w[
  .wav .vtf .mp3 .webm .mdl .dds .usm .vvd
  resource/flash3/images/econ
  resource/flash3/images/sets
  resource/flash3/images/hud_skins
]

sh 'mkdir', '-p', 'dota/resource'
sh 'cp', '-r', "#{dota}/dota/resource/", 'dota/'
Dir.glob('dota/resource/dota_*.txt') do |f|
  sh 'file', f
  sh 'iconv', '--verbose', '-f', 'utf-16', '-t', 'utf-8', '-o', "#{f}.utf8", f
  sh 'mv', "#{f}.utf8", f
  sh 'dos2unix', f
end

sh 'git', 'add', 'dota'
sh 'git', 'add', '-u', 'dota'

Dir.glob("#{dota}/**/*_dir.vpk") do |vpk|
  target = File.basename(vpk.sub(dota+"/", '').tr('/', '_'), '_dir.vpk')
  next if target =~ /dota_sound_vo_english|dota_scaleform_cache/

  sh './d2vpk', vpk, target, *ignore

  Dir.glob("#{target}/**/*.txt"){|f| sh 'dos2unix', f }

  sh 'git', 'add', target
end

system('git', 'commit', '-v')
