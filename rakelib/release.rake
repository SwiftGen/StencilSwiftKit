# frozen_string_literal: true

# Used constants:
# - BUILD_DIR

def first_match_in_file(file, regexp)
  File.foreach(file) do |line|
    m = regexp.match(line)
    return m if m
  end
end

## [ Release a new version ] ##################################################

namespace :release do
  desc 'Create a new release on CocoaPods'
  task :new => [:check_versions, :check_tag_and_ask_to_release, 'spm:test', :github, :cocoapods]

  desc 'Check if all versions from the podspecs and CHANGELOG match'
  task :check_versions do
    results = []

    Utils.table_header('Check', 'Status')

    # Check if bundler is installed first, as we'll need it for the cocoapods task (and we prefer to fail early)
    `which bundler`
    results << Utils.table_result(
      $CHILD_STATUS.success?,
      'Bundler installed',
      'Please install bundler using `gem install bundler` and run `bundle install` first.'
    )

    # Extract version from podspec
    podspec_version = Utils.podspec_version(POD_NAME)
    Utils.table_info("#{POD_NAME}.podspec", podspec_version)

    # Check if entry present in CHANGELOG
    changelog_entry = first_match_in_file('CHANGELOG.md', /^## #{Regexp.quote(podspec_version)}$/)
    results << Utils.table_result(
      changelog_entry,
      'CHANGELOG, Entry added',
      "Please add an entry for #{podspec_version} in CHANGELOG.md"
    )

    changelog_has_stable = system("grep -qi '^## Stable Branch' CHANGELOG.md")
    results << Utils.table_result(
      !changelog_has_stable,
      'CHANGELOG, No stable',
      'Please remove section for stable branch in CHANGELOG'
    )

    exit 1 unless results.all?
  end

  desc "Check tag and ask to release"
  task :check_tag_and_ask_to_release do
    results = []
    podspec_version = Utils.podspec_version(POD_NAME)

    tag_set = !`git ls-remote --tags . refs/tags/#{podspec_version}`.empty?
    results << Utils.table_result(
      tag_set,
      'Tag pushed',
      'Please create a tag and push it'
    )

    exit 1 unless results.all?

    print "Release version #{podspec_version} [Y/n]? "
    exit 2 unless STDIN.gets.chomp == 'Y'
  end

  desc "Create a new GitHub release"
  task :github do
    require 'octokit'

    client = Utils.octokit_client
    tag = Utils.top_changelog_version
    body = Utils.top_changelog_entry

    raise 'Must be a valid version' if tag == 'Stable Branch'

    repo_name = File.basename(`git remote get-url origin`.chomp, '.git').freeze
    puts "Pushing release notes for tag #{tag}"
    client.create_release("SwiftGen/#{repo_name}", tag, name: tag, body: body)
  end

  desc "pod trunk push #{POD_NAME} to CocoaPods"
  task :cocoapods do
    Utils.print_header 'Pushing pod to CocoaPods Trunk'
    sh "bundle exec pod trunk push #{POD_NAME}.podspec"
  end
end
