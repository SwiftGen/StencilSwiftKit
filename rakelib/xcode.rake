namespace :xcode do
  desc 'Build using Xcode'
  task :build do |task|
    xcrun(%Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{TARGET_NAME}" -configuration "#{CONFIGURATION}" build-for-testing), task)
  end

  desc 'Run Xcode Unit Tests'
  task :test => :build do |task|
    xcrun(%Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{TARGET_NAME}" -configuration "#{CONFIGURATION}" test-without-building), task)
  end
end
