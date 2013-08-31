#!/usr/bin/env ruby

dota = "#{ENV["HOME"]}/.steam/steam/SteamApps/common/dota\ 2\ beta"

Dir.glob("#{dota}/**/*_dir.vpk") do |vpk|
  target = File.basename(vpk.sub(dota+"/", '').tr('/', '_'), '_dir.vpk')
  next if target == "dota_sound_vo_english"

  system('./d2vpk', vpk, target)
  Dir.glob(target+"/**/*.{wav,vtf,mp3,webm,mdl,dds,usm,vvd}") do |rm|
    File.unlink(rm)
  end
end

system('rm', '-rf', "dota_pak01/resource/flash3/images/econ")
system('rm', '-rf', "dota_pak01/resource/flash3/images/sets")
system('rm', '-rf', "dota_pak01/resource/flash3/images/hud_skins")
system('rm', '-rf', "dota_sound_vo_english")
