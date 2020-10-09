platform :osx, '10.9'
use_frameworks!

raise 'Please use bundle exec to run the pod command' unless defined?(Bundler)

install! 'cocoapods',
  :generate_multiple_pod_projects => true,
  :incremental_installation => true

workspace 'StencilSwiftKit.xcworkspace'

target 'Tests' do
  pod 'StencilSwiftKit', path: '.'
  pod 'SwiftLint', '~> 0.31'
end
