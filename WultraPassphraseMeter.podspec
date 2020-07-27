Pod::Spec.new do |s|
  s.name             = 'WultraPassphraseMeter'
  s.version          = '1.0.1'
  s.summary          = 'Streng tester for passwords and passcodes.'
  s.description      = 'A library that checks the strength of a pin or a password.'
  s.social_media_url = 'https://twitter.com/wultra'
  s.homepage         = 'https://wultra.com'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'Wultra s.r.o.' => 'support@wultra.com' }
  s.source           = { :git => 'https://github.com/wultra/passphrase-meter.git', :tag => s.version.to_s }
  s.swift_versions   = ['5.0']

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |sub|
    sub.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/Source/src_native'}
    sub.preserve_paths = 'Source/src_native/module.modulemap'
    sub.source_files = 'Source/src_native/*.{c,h}', 'Source/src_ios/PasswordTester.swift'
    sub.private_header_files = 'Source/src_native/*.{h}'
  end

  
  s.subspec 'Dictionary_czsk' do |sub|
    sub.resources = 'dictionaries/czsk.dct'
    sub.source_files = 'Source/src_ios/PasswordTester_czsk.swift'
    sub.dependency 'WultraPassphraseMeter/Core'
  end

  s.subspec 'Dictionary_en' do |sub|
    sub.resources = 'dictionaries/en.dct'
    sub.source_files = 'Source/src_ios/PasswordTester_en.swift'
    sub.dependency 'WultraPassphraseMeter/Core'
  end

end
