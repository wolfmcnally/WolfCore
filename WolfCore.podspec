#
# Be sure to run `pod lib lint WolfCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WolfCore'
  s.version          = '2.1.3'
  s.summary          = 'A library of conveniences for Swift, iOS, MacOS, tvOS, WatchOS, and Linux.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
WolfCore is a library of conveniences for constructing Swift applications in iOS, tvOS, MacOS, WatchOS, and Linux. WolfCore is maintained by Wolf McNally.

Over the years I've carried a continuously-evolving tool kit of software tools and techniques that I use to avoid re-inventing the wheel. It's had many iterations over the years and WolfCore is the latest— open source (MIT license), cross-platform (iOS, MacOS, tvOS, WatchOS, and Linux), pure Swift (including Foundation and GCD under Linux) It's basically a collection of embodied conveniences and best practices that make the code built on it easier to read, write, and maintain, often reducing or eliminating the need for boilerplate code.

The purpose of WolfCore is different than many third-party libraries. It neither solves a narrow problem, like many do, nor does it dictate the structure of how the whole app is written, like Xamarin or even UIKit does. It's purpose is to be a general purpose tool kit that streamlines the code that performs the actual work of the app. Its use, while optional at every step, reduces the number of lines of code you actually have to write and understand, and it covers areas that are common in many productivity apps. WolfCore reduces the need to add third-party libraries (which often integrate poorly with one another).
                       DESC

  s.homepage         = 'https://github.com/wolfmcnally/WolfCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wolfmcnally' => 'wolf@wolfmcnally.com' }
  s.source           = { :git => 'https://github.com/wolfmcnally/WolfCore.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/wolfmcnally'

  s.swift_version = '4.0'

  s.source_files = 'WolfCore/Classes/Shared/**/*'
  s.dependency 'CommonCryptoModule'

  s.ios.deployment_target = '9.3'
  s.ios.source_files = 'WolfCore/Classes/iOS/**/*', 'WolfCore/Classes/iOSShared/**/*', 'WolfCore/Classes/AppleShared/**/*'
  s.ios.resources = 'WolfCore/Assets/*'

  s.macos.deployment_target = '10.13'
  s.macos.source_files = 'WolfCore/Classes/macOS/**/*', 'WolfCore/Classes/AppleShared/**/*'

  s.tvos.deployment_target = '11.0'
  s.tvos.source_files = 'WolfCore/Classes/tvOS/**/*', 'WolfCore/Classes/iOSShared/**/*', 'WolfCore/Classes/AppleShared/**/*'

  # s.resource_bundles = {
  #   'WolfCore' => ['WolfCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end