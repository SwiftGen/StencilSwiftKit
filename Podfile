platform :osx, '10.9'
use_frameworks!

def common_pods
  pod 'Stencil', :git => 'https://github.com/kylef/Stencil', :inhibit_warnings => true
  pod 'StencilSwiftKit', :path => '.'
end

target 'Tests' do
  common_pods()
end
