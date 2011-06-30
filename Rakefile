require 'rake'
task :package do
  filename = 'gosu-mac-wrapper-0.7.33.tar.gz'
  unless FileTest.exists? filename
    `curl -O http://www.libgosu.org/downloads/#{filename}`
  end
  `tar xzf #{filename}`

  if FileTest.exists? 'Spacegame.app'
    rm_rf 'Spacegame.app'
  end

  mv 'RubyGosu App.app', 'Spacegame.app'

  # Info.plist file
  info = File.read('Spacegame.app/Contents/Info.plist')
  info.sub!('org.libgosu.UntitledGame', 'com.github.veryhappythings.spacegame')
  info.sub!('RubyGosu App', 'Spacegame')
  File.open('Spacegame.app/Contents/Info.plist', 'w') {|f| f.puts info}

  cp_r 'lib/spacegame', 'Spacegame.app/Contents/Resources'
  cp_r 'media', 'Spacegame.app/Contents/Resources'
  cp 'lib/spacegame.rb', 'Spacegame.app/Contents/Resources'
  mv 'Spacegame.app/Contents/MacOS/RubyGosu App', 'Spacegame.app/Contents/MacOS/Spacegame'

  info = File.read('bin/client')
  info.sub!("require_relative '../lib/spacegame'", "require_relative 'spacegame'")
  File.open('Spacegame.app/Contents/Resources/Main.rb', 'w') {|f| f.puts info}
end
