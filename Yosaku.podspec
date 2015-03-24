#
# Be sure to run `pod lib lint Yosaku.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Yosaku'
  s.version          = '0.2.0'
  s.summary          = 'A log viewer for Cocoa Touch.'
  s.description      = <<-DESC
                       A log viewer for Cocoa Touch.

                       * Yosaku depends on CocoaLumberjack.
                       * Yosaku uses UITableView for displaying log messages.
                       DESC
  s.homepage         = 'https://github.com/sgr/Yosaku'
  s.screenshots      = 'https://github.com/sgr/Yosaku/raw/master/Resources/iPhone_portrait.png', 'https://github.com/sgr/Yosaku/raw/master/Resources/iPhone_landscape.png', 'https://github.com/sgr/Yosaku/raw/master/Resources/iPad_portrait.png', 'https://github.com/sgr/Yosaku/raw/master/Resources/iPad_landscape.png'
  s.license          = 'MIT'
  s.author           = 'Shigeru Fujiwara'
  s.source           = { :git => 'https://github.com/sgr/Yosaku.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.google.com/+ShigeruFujiwara3'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Classes/*.xib'
  s.public_header_files = 'Pod/Classes/YSLogger.h'

  s.dependency 'CocoaLumberjack', '~> 2.0'
end
