namespace :spm do
  desc 'Build using SPM'
  task :build do |task|
    xcrun("swift build", task)
  end

  desc 'Run SPM Unit Tests'
  task :test => :build do |task|
    xcrun("swift test", task)
  end
end
