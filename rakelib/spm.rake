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
