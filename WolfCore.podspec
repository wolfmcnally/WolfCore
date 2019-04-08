Pod::Spec.new do |s|
  s.name             = 'WolfCore'
  s.version          = '4.0.1'
  s.summary          = 'A library of conveniences for Swift, iOS, MacOS, tvOS, WatchOS, and Linux.'
  s.description      = <<-DESC
WolfCore is a library of conveniences for constructing Swift applications in iOS, tvOS, MacOS, WatchOS, and Linux. WolfCore is maintained by Wolf McNally.
                       DESC

  s.homepage         = 'https://github.com/wolfmcnally/WolfCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wolfmcnally' => 'wolf@wolfmcnally.com' }
  s.source           = { :git => 'https://github.com/wolfmcnally/WolfCore.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/wolfmcnally'

  s.swift_version = '5.0'

  s.ios.deployment_target = '9.3'
  s.macos.deployment_target = '10.13'
  s.tvos.deployment_target = '11.0'
  s.source_files = 'Sources/WolfCore/**/*'

  s.dependency 'WolfNesting'
  s.dependency 'WolfNumerics'
  s.dependency 'WolfOSBridge'
  s.dependency 'WolfPipe'
  s.dependency 'ExtensibleEnumeratedName'
  s.dependency 'WolfWith'
  s.dependency 'WolfStrings'
  s.dependency 'WolfFoundation'
end
