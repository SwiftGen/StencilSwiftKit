#!/usr/bin/rake

## [ Constants ] ##############################################################

WORKSPACE = 'StencilSwiftKit'.freeze
SCHEME_NAME = 'Tests'.freeze
CONFIGURATION = 'Debug'.freeze
POD_NAME = 'StencilSwiftKit'.freeze

## [ Release a new version ] ##################################################

namespace :release do
  desc 'Create a new release on CocoaPods'
  task new: [:check_versions, 'xcode:test', :cocoapods]

  desc 'Check if all versions from the podspecs and CHANGELOG match'
  task :check_versions do
    results = []

    # Check if bundler is installed first, as we'll need it for the cocoapods task (and we prefer to fail early)
    `which bundler`
    results << Utils.table_result($CHILD_STATUS.success?, 'Bundler installed', 'Please install bundler using `gem install bundler` and run `bundle install` first.')

    # Extract version from podspec
    podspec_version = Utils.podspec_version(POD_NAME)
    Utils.table_info("#{POD_NAME}.podspec", podspec_version)

    # Check if version in Podfile.lock matches
    podfile_lock_version = Utils.podfile_lock_version(POD_NAME)
    results << Utils.table_result(podfile_lock_version == podspec_version, 'Podfile.lock', 'Please run pod install')

    # Check if entry present in CHANGELOG
    changelog_entry = system(%(grep -q '^## #{Regexp.quote(podspec_version)}$' CHANGELOG.md))
    results << Utils.table_result(changelog_entry, 'CHANGELOG, Entry added', "Please add an entry for #{podspec_version} in CHANGELOG.md")

    changelog_master = system("grep -qi '^## Master' CHANGELOG.md")
    results << Utils.table_result(!changelog_master, 'CHANGELOG, No master', 'Please remove entry for master in CHANGELOG')

    tag_set = !`git ls-remote --tags . refs/tags/#{podspec_version}`.empty?
    results << Utils.table_result(tag_set, 'Tag pushed', 'Please create a tag and push it')

    exit 1 unless results.all?

    print "Release version #{podspec_version} [Y/n]? "
    exit 2 unless STDIN.gets.chomp == 'Y'
  end

  desc "pod trunk push #{POD_NAME} to CocoaPods"
  task :cocoapods do
    Utils.print_header 'Pushing pod to CocoaPods Trunk'
    sh "bundle exec pod trunk push #{POD_NAME}.podspec"
  end
end

task default: 'xcode:test'
