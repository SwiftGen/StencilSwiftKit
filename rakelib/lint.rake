namespace :lint do
  desc 'Install swiftlint'
  task :install do |task|
    swiftlint = `which swiftlint`
    
    if !(swiftlint && $?.success?)
      url = 'https://github.com/realm/SwiftLint/releases/download/0.16.1/SwiftLint.pkg'
      tmppath = '/tmp/SwiftLint.pkg'

      plain([
        "curl -Lo #{tmppath} #{url}",
        "sudo installer -pkg #{tmppath} -target /"
      ], task)
    end
  end
  
  desc 'Lint the code'
  task :code => :install do |task|
    print_info 'Linting the code'
    plain(%Q(swiftlint lint --no-cache --strict --path Sources), task)
  end
  
  desc 'Lint the tests'
  task :tests => :install do |task|
    print_info 'Linting the unit test code'
    plain(%Q(swiftlint lint --no-cache --strict --path "Tests/#{POD_NAME}Tests"), task)
  end
end
