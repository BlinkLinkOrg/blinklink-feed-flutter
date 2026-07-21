Pod::Spec.new do |s|
  s.name             = 'blinklink_feed'
  s.version          = '0.1.0'
  s.summary          = 'Blinklink server-driven short-form video feeds for Flutter.'
  s.description      = <<-DESC
Blinklink server-driven short-form video feeds for Flutter — a thin
passthrough over the native Blinklink iOS SDK.
                       DESC
  s.homepage         = 'https://github.com/BlinkLinkOrg/blinklink-feed-flutter'
  s.license          = { :type => 'Blinklink Source-Available', :file => '../LICENSE' }
  s.author           = { 'Blinklink' => 'support@blinklink.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.resource_bundles = { 'blinklink_feed_privacy' => ['Resources/PrivacyInfo.xcprivacy'] }

  s.platform         = :ios, '15.0'
  s.swift_version    = '5.10'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.dependency 'Flutter'
  s.dependency 'BlinklinkFeed', '~> 0.1'
end
