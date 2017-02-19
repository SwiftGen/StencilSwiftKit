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

namespace :spm do
  desc 'Build using SPM'
  task :build do
    plain("swift build", "spm_build")
  end

  desc 'Run SPM Unit Tests'
  task :test => :build do
    plain("swift test", "spm_build")
  end
end

namespace :xcode do
  desc 'Build using Xcode'
  task :build do
    xcpretty("xcodebuild -workspace StencilSwiftKit.xcworkspace -scheme Tests build-for-testing", "xcode_build")
  end

  desc 'Run Xcode Unit Tests'
  task :test => :build do
    xcpretty("xcodebuild -workspace StencilSwiftKit.xcworkspace -scheme Tests test-without-building", "xcode_test")
  end
end

desc 'Lint the Pod'
task :lint do
  plain("pod lib lint StencilSwiftKit.podspec --quick", "lint")
end

task :default => "xcode:test"
