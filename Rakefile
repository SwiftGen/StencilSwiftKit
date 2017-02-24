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

def plain(cmd, task)
  name = task.name.gsub(/:/,"_")
  if ENV['CI']
    sh "set -o pipefail && #{cmd} | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\""
  else
    sh cmd
  end
end

namespace :spm do
  desc 'Build using SPM'
  task :build do |task|
    plain("swift build", task)
  end

  desc 'Run SPM Unit Tests'
  task :test => :build do |task|
    plain("swift test", task)
  end
end

namespace :xcode do
  desc 'Build using Xcode'
  task :build do |task|
    xcpretty("xcodebuild -workspace StencilSwiftKit.xcworkspace -scheme Tests build-for-testing", task)
  end

  desc 'Run Xcode Unit Tests'
  task :test => :build do |task|
    xcpretty("xcodebuild -workspace StencilSwiftKit.xcworkspace -scheme Tests test-without-building", task)
  end
end

namespace :lint do
  desc 'Install swiftlint'
  task :install do |task|
    swiftlint = `which swiftlint`
    
    if !(swiftlint && $?.success?)
      url = 'https://github.com/realm/SwiftLint/releases/download/0.16.1/SwiftLint.pkg'
      tmppath = '/tmp/SwiftLint.pkg'

      plain("curl -Lo #{tmppath} #{url}", task)
      plain("sudo installer -pkg #{tmppath} -target /", task)
    end
  end
  
  desc 'Lint the code'
  task :code => :install do |task|
    plain("swiftlint lint --no-cache --strict --path Sources", task)
  end
  
  desc 'Lint the tests'
  task :tests => :install do |task|
    plain("swiftlint lint --no-cache --strict --path Tests/StencilSwiftKitTests", task)
  end
end

namespace :pod do
  desc 'Lint the Pod'
  task :lint do |task|
    plain("pod lib lint StencilSwiftKit.podspec --quick", task)
  end
end

task :default => "xcode:test"
