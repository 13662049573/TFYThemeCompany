platform :ios, '13.0'

target 'TFYThemeCompany' do
  
  inhibit_all_warnings!

  pod 'TFY_Navigation'
  pod 'TFY_LayoutCategoryKit'
  pod 'TFY_TabBarKit'
  pod 'TFYCrashSDK'
  
  pod 'Masonry'
  pod 'SDWebImage'
  pod 'YYModel'
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = "NO"
        end
    end
end
