raise 'Please use bundle exec to run the pod command' unless defined?(Bundler)

platform :osx, '10.9'
source 'https://cdn.jsdelivr.net/cocoa/'
use_frameworks!

target 'Tests' do
  pod 'StencilSwiftKit', path: '.'
  pod 'SwiftLint', '~> 0.31'
end
