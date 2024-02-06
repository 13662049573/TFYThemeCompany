
Pod::Spec.new do |spec|

  spec.name         = "TFYThemeKit"

  spec.version      = "1.0.0"

  spec.summary      = "主题配置，自定义和网络都可以使用，最低支持iOS13以上版本。"

  spec.description  = <<-DESC
主题配置，自定义和网络都可以使用，最低支持iOS13以上版本。
                   DESC

  spec.homepage     = "http://EXAMPLE/TFYThemeKit"
  
  spec.license      = "MIT"
 
  spec.author       = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "13.0"

  spec.source       = { :git => "http://EXAMPLE/TFYThemeKit.git", :tag => spec.version}

  spec.source_files  = "TFYThemeCompany/TFYThemeKit/TFYThemeKit.h"
  
  spec.subspec 'TFY_NavControoler' do |ss|
    ss.source_files = "TFYThemeCompany/TFYThemeKit/TFYThemeKit/**/*.{h,m}"
    ss.resources    = "TFYThemeKit/TFYThemeKit/TFYThemeKit.bundle"
    ss.subspec 'TFYminizip' do |s|
        s.source_files  = "TFYThemeKit/TFYThemeKit/TFYminizip/**/*.{h,c}"
     end
  end

  spec.frameworks   = "Foundation","UIKit"

  spec.xcconfig     = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include" }
  
  spec.requires_arc = true
  
end