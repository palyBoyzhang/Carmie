install! 'cocoapods', :disable_input_output_paths => true  

platform :ios, "15.0"
target 'Carmie' do
  
  use_frameworks!
  inhibit_all_warnings!

 pod 'IQKeyboardManager'
 pod 'RTRootNavigationController'
 pod 'TZImagePickerController'
 pod 'UITextView+Placeholder'
 pod 'TYAlertController'
 pod 'AFNetworking'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end


