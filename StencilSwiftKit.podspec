Pod::Spec.new do |s|

  s.name         = "StencilSwiftKit"
  s.version      = "0.0.1"
  s.summary      = "Stencil additions dedicated for Swift code generation"

  s.description  = <<-DESC
                   TODO
                   DESC

  s.homepage     = "https://github.com/SwiftGen/StencilSwiftKit"
  s.license      = "MIT"
  s.author       = { "Olivier Halligon" => "olivier@halligon.net" }
  s.social_media_url = "https://twitter.com/aligatr"

  s.platform = :osx, '10.9'

  s.source       = { :git => "https://github.com/SwiftGen/StencilSwiftKit.git", :tag => s.version.to_s }

  s.source_files = "Sources/**/*.swift"

  s.dependency 'Stencil', '~> 0.7.0'
  s.framework  = "Foundation"
end
