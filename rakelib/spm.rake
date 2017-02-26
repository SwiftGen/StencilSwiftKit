namespace :spm do
  desc 'Build using SPM'
  task :build do |task|
  	print_info 'Compile using SPM'
    xcrun("swift build", task)
  end

  desc 'Run SPM Unit Tests'
  task :test => :build do |task|
  	print_info 'Run the unit tests using SPM'
    xcrun("swift test", task)
  end
end
