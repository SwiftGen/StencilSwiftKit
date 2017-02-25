namespace :pod do
  desc 'Lint the Pod'
  task :lint do |task|
    plain(%Q(pod lib lint "#{POD_NAME}.podspec" --quick), task)
  end
end
