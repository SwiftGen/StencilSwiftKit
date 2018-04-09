platform :osx, '10.9'
use_frameworks!

target 'Tests' do
  pod 'StencilSwiftKit', path: '.'
  pod 'SwiftLint', '~> 0.25'
end

post_install do |installer|
  swift3_pods = %w(Stencil)
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.2' if swift3_pods.include?(target.name)
    end
  end
end
