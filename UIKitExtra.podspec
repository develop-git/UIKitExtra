#
# Be sure to run `pod lib lint UIKitExtra.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIKitExtra'
  s.version          = '1.2.0'
  s.summary          = 'A short description of UIKitExtra.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    部分UI控件扩展
                       DESC

  s.homepage         = 'https://github.com/develop-git/UIKitExtra'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jian' => 'develop-work@outlook.com' }
  s.source           = { :git => 'https://github.com/develop-git/UIKitExtra.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'UIKitExtra/Classes/**/*'
  
  s.requires_arc = true
  s.swift_versions = ['5.1']
  s.xcconfig = {
    'LIBRARY_SEARCH_PATHS' => '$(SDKROOT)/usr/lib/swift',
  }
  
  # s.resource_bundles = {
  #   'UIKitExtra' => ['UIKitExtra/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
