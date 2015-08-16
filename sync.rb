#!/usr/bin/env ruby
require 'rake'

dota = File.expand_path("~/Steam/steamapps/common/dota 2 beta/")

sh 'mkdir', '-p', 'dota/resource'
sh 'cp', '-r', "#{dota}/dota/resource/", 'dota/'

convert = ->(path){
  return if path =~ /ti_2013_podseats\.txt/
  file = `file "#{path}"`
  case file
  when /UTF-16 Unicode text/
    sh 'iconv', '--verbose', '-f', 'utf-16', '-t', 'utf-8', '-o', "#{path}.utf8", path
    sh 'mv', "#{path}.utf8", path
  when /(UTF-8 Unicode|ASCII) text/
  else
    p file
  end

  if file =~ /with CRLF(, CR)? line terminators/
    sh 'dos2unix', '-q', path
  end
}

Dir.glob('**/*.{vdf,res,txt}') do |txt|
  convert.(txt)
end

sh 'git', 'add', 'dota'
sh 'git', 'add', '-u', 'dota'

Dir.glob("#{dota}/**/*_dir.vpk") do |vpk|
  target = File.basename(vpk.sub(dota+"/", '').tr('/', '_'), '_dir.vpk')
  next if target =~ /dota_sound_vo_english|dota_scaleform_cache/

  sh './d2vpk', vpk, target

  Dir.glob("#{target}/**/*.{vdf,res,txt}"){|f| convert.(f) }

  sh 'git', 'add', target
end
