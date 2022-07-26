# frozen_string_literal: true

# Used constants:
# _none_

require_relative 'check_changelog'

namespace :changelog do
  desc 'Add the empty CHANGELOG entries after a new release'
  task :reset do
    changelog = File.read('CHANGELOG.md')
    abort('A Stable entry already exists') if changelog =~ /^##\s*Stable Branch$/
    changelog.sub!(/^##[^#]/, "#{header}\\0")
    File.write('CHANGELOG.md', changelog)
  end

  def header
    <<-HEADER.gsub(/^\s*\|/, '')
      |## Stable Branch
      |
      |### Breaking Changes
      |
      |_None_
      |
      |### New Features
      |
      |_None_
      |
      |### Bug Fixes
      |
      |_None_
      |
      |### Internal Changes
      |
      |_None_
      |
    HEADER
  end

  desc 'Check if links to issues and PRs use matching numbers between text & link'
  task :check do
    warnings = check_changelog
    if warnings.empty?
      puts "\u{2705}  All entries seems OK (end with period + 2 spaces, correct links)"
    else
      puts "\u{274C}  Some warnings were found:\n" + Array(warnings.map do |warning|
        " - Line #{warning[:line]}: #{warning[:message]}"
      end).join("\n")
      exit 1
    end
  end

  desc "Push the CHANGELOG's top section as a GitHub release"
  task :push_github_release do
    require 'octokit'

    client = Utils.octokit_client
    tag = Utils.top_changelog_version
    body = Utils.top_changelog_entry

    repo_name = File.basename(`git remote get-url origin`.chomp, '.git').freeze
    puts "Pushing release notes for tag #{tag}:"
    puts body
    client.create_release("SwiftGen/#{repo_name}", tag, name: tag, body: body)
  end
end
