namespace :pod do
  desc 'Lint the Pod'
  task :lint do |task|
    plain("pod lib lint #{TARGET_NAME}.podspec --quick", task)
  end
end
