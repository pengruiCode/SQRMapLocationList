Pod::Spec.new do |s|

  s.name         = "SQRMapLocationList"
  s.version      = "0.0.3"
  s.summary  	 = '地图组件'
  s.homepage     = "https://github.com/pengruiCode/SQRMapLocationList.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = {'pengrui' => 'pengruiCode@163.com'}
  s.source       = { :git => 'https://github.com/pengruiCode/SQRMapLocationList.git', :tag => s.version}
  s.platform 	 = :ios, "8.0"
  s.source_files = "SQRMapLocationList/**/*.{h,m}"
 
  s.resource     = 'SQRMapLocationList/Resource/*.png'
  s.requires_arc = true
  s.description  = <<-DESC
			显示地图，并定位出附近位置列表
                   DESC

 end