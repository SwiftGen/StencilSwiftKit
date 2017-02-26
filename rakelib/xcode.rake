namespace :xcode do
  desc 'Build using Xcode'
  task :build do |task|
  	print_info 'Compile using Xcode'
    xcrun(%Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{TARGET_NAME}" -configuration "#{CONFIGURATION}" build-for-testing), task)
  end

  desc 'Run Xcode Unit Tests'
  task :test => :build do |task|
  	print_info 'Run the unit tests using Xcode'
    xcrun(%Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "#{TARGET_NAME}" -configuration "#{CONFIGURATION}" test-without-building), task)
  end
end
