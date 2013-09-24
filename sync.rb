#!/usr/bin/env ruby

dota = "#{ENV["HOME"]}/.steam/steam/SteamApps/common/dota\ 2\ beta"
ignore = %w[
  .wav .vtf .mp3 .webm .mdl .dds .usm .vvd
  resource/flash3/images/econ
  resource/flash3/images/sets
  resource/flash3/images/hud_skins
]

Dir.glob("#{dota}/**/*_dir.vpk") do |vpk|
  target = File.basename(vpk.sub(dota+"/", '').tr('/', '_'), '_dir.vpk')
  next if target =~ /dota_sound_vo_english|dota_scaleform_cache/

  system('./d2vpk', vpk, target, *ignore)
  system('git', 'add', target)
  system('git', 'commit', '-v')
end
