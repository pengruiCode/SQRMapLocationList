Pod::Spec.new do |s|

  s.name         = "SQRMapLocationList"
  s.version      = "0.1.9"
  s.summary  	 = '地图组件'
  s.homepage     = "https://github.com/pengruiCode/SQRMapLocationList.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = {'pengrui' => 'pengruiCode@163.com'}
  s.source       = { :git => 'https://github.com/pengruiCode/SQRMapLocationList.git', :tag => s.version}
  s.platform 	 = :ios, "8.0"
  s.source_files = "SQRMapLocationList/**/*.{h,m}"
  s.resource     = 'SQRMapLocationList/Resource/*.{png,xib}'
  s.requires_arc = true
  s.description  = <<-DESC
			显示地图，并定位出附近位置列表
                   DESC

  s.subspec "AMap2DMap-NO-IDFA" do |ss|
     ss.dependency "AMap2DMap-NO-IDFA"
  end

  s.subspec "AMapSearch-NO-IDFA" do |ss|
     ss.dependency "AMapSearch-NO-IDFA"
  end

  s.subspec "AMapLocation-NO-IDFA" do |ss|
     ss.dependency "AMapLocation-NO-IDFA"
  end

  s.subspec "SQRBaseClassProject" do |ss|
     ss.dependency "SQRBaseClassProject"
  end

  s.subspec "SQRBaseDefineWithFunction" do |ss|
     ss.dependency "SQRBaseDefineWithFunction"
  end

 end