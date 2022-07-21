Pod::Spec.new do |s|
  s.name         = 'StencilSwiftKit'
  s.version      = '2.9.0'
  s.summary      = 'Stencil additions dedicated for Swift code generation'

  s.description  = <<-DESC
                   This pod contains some additional nodes and filters for
                   [Stencil](https://github.com/stencilproject/Stencil).
                   These additional nodes & filters are mainly dedicated
                   for writing Stencil templates generating *Swift* code.
                   DESC

  s.homepage     = 'https://github.com/SwiftGen/StencilSwiftKit'
  s.license      = 'MIT'
  s.author       = {
    'Olivier Halligon' => 'olivier@halligon.net',
    'David Jennes' => 'david.jennes@gmail.com'
  }
  s.social_media_url = 'https://twitter.com/aligatr'

  s.platform = :osx, '10.9'
  s.swift_versions = ['5.0']
  s.cocoapods_version = '>= 1.9.0'

  s.source       = {
    git: 'https://github.com/SwiftGen/StencilSwiftKit.git',
    tag: s.version.to_s
  }
  s.source_files = 'Sources/**/*.swift'

  s.dependency 'Stencil', '~> 0.14.0'
  s.framework = 'Foundation'
end
