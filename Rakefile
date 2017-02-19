def xcpretty(cmd, name)
  if ENV['CI']
    sh "set -o pipefail && #{cmd} | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\" | xcpretty --color --report junit --output \"#{ENV['CIRCLE_TEST_REPORTS']}/xcode/#{name}.xml\""
  elsif `which xcpretty` && $?.success?
    sh "set -o pipefail && #{cmd} | xcpretty -c"
  else
    sh cmd
  end
end

def plain(cmd, name)
  if ENV['CI']
    sh "set -o pipefail && #{cmd} | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\""
  else
    sh cmd
  end
end

task :spm_build do
  plain("swift build", "spm_build")
end

task :xcode_build do
  xcpretty("xcodebuild -workspace StencilSwiftKit.xcworkspace -scheme Tests build-for-testing", "xcode_build")
end

desc 'Run Xcode Unit Tests'
task :xcode_test => :xcode_build do
  xcpretty("xcodebuild -workspace StencilSwiftKit.xcworkspace -scheme Tests test-without-building", "xcode_test")
end

desc 'Run SPM Unit Tests'
task :spm_test => :spm_build do
  plain("swift test", "spm_build")
end

desc 'Lint the Pod'
task :lint do
  plain("pod lib lint StencilSwiftKit.podspec --quick", "lint")
end

task :default => :xcode_test
