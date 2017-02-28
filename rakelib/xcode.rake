namespace :xcode do
  desc 'Build using Xcode'
  task :build do |task|
    Utils.print_info 'Compile using Xcode'
    Utils.run(%Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{TARGET_NAME}" -configuration "#{CONFIGURATION}" build-for-testing), task, xcrun: true, xcpretty: true)
  end

  desc 'Run Xcode Unit Tests'
  task :test => :build do |task|
    Utils.print_info 'Run the unit tests using Xcode'
    Utils.run(%Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{TARGET_NAME}" -configuration "#{CONFIGURATION}" test-without-building), task, xcrun: true, xcpretty: true)
  end
end
