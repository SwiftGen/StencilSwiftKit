# run a command, pipe output through 'xcpretty' and store the output in CI artifacts
def xcpretty(cmd, task)
  name = task.name.gsub(/:/,"_")
  xcpretty = `which xcpretty`

  if ENV['CI']
    sh "set -o pipefail && #{cmd} | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\" | xcpretty --color --report junit --output \"#{ENV['CIRCLE_TEST_REPORTS']}/xcode/#{name}.xml\""
  elsif xcpretty && $?.success?
    sh "set -o pipefail && #{cmd} | xcpretty -c"
  else
    sh cmd
  end
end

# run a command and store the output in CI artifacts
def plain(cmd, task)
  name = task.name.gsub(/:/,"_")
  if ENV['CI']
    sh "set -o pipefail && #{cmd} | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\""
  else
    sh cmd
  end
end

# select the xcode version we want/support
def version_select
  xcodes = `mdfind "kMDItemCFBundleIdentifier = 'com.apple.dt.Xcode' && kMDItemVersion = '8.*'"`.chomp.split("\n")
  if xcodes.empty?
    raise "\n[!!!] You need to have Xcode 8.x to compile SwiftGen.\n\n"
  end
  
  # Order by version and get the latest one
  vers = lambda { |path| `mdls -name kMDItemVersion -raw "#{path}"` }
  latest_xcode_version = xcodes.sort { |p1, p2| vers.call(p1) <=> vers.call(p2) }.last
  %Q(DEVELOPER_DIR="#{latest_xcode_version}/Contents/Developer")
end

def xcrun(cmd, task, pretty=true)
  if pretty
    xcpretty("#{version_select} xcrun #{cmd}", task)
  else
    plain("#{version_select} xcrun #{cmd}", task)
  end
end
