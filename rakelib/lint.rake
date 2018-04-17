# Used constants:
# none

namespace :lint do
  SWIFTLINT = 'Scripts/SwiftLint.sh'.freeze

  desc 'Lint the code'
  task :code do |task|
    Utils.print_header 'Linting the code'
    Utils.run(%(#{SWIFTLINT} sources), task)
  end

  desc 'Lint the tests'
  task :tests do |task|
    Utils.print_header 'Linting the unit test code'
    Utils.run(%(#{SWIFTLINT} tests), task)
  end

  if File.directory?('Tests/Fixtures/Generated')
    desc 'Lint the output'
    task :output do |task|
      Utils.print_header 'Linting the template output code'
      Utils.run(%(#{SWIFTLINT} generated), task)
    end
  end
end
