#!/usr/bin/env ruby
require 'rake'

# dota = "#{ENV["HOME"]}/.steam/steam/SteamApps/common/dota\ 2\ test"
dota = "#{ENV["HOME"]}/.steam/steam/SteamApps/common/dota\ 2\ beta"

sh 'mkdir', '-p', 'dota/resource'
sh 'cp', '-r', "#{dota}/dota/resource/", 'dota/'

Dir.glob('dota/resource/*.txt') do |txt|
  file = `file "#{txt}"`
  if file =~ /UTF-16 Unicode text/
    sh 'iconv', '--verbose', '-f', 'utf-16', '-t', 'utf-8', '-o', "#{txt}.utf8", txt
    sh 'mv', "#{txt}.utf8", txt
  else
    p file
  end
  if file =~ /with CRLF(, CR)? line terminators/
    sh 'dos2unix', '-q', txt
  end
end

sh 'git', 'add', 'dota'
sh 'git', 'add', '-u', 'dota'

Dir.glob("#{dota}/**/*_dir.vpk") do |vpk|
  target = File.basename(vpk.sub(dota+"/", '').tr('/', '_'), '_dir.vpk')
  next if target =~ /dota_sound_vo_english|dota_scaleform_cache/

  sh './d2vpk', vpk, target

  Dir.glob("#{target}/**/*.{vdf,res,txt}"){|f| sh 'dos2unix', '-q', f }

  sh 'git', 'add', target
end

system('git', 'commit', '-v')
