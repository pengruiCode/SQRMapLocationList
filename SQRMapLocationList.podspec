Pod::Spec.new do |s|

  s.name         = "SQRMapLocationList"
  s.version      = "0.0.1"
  s.summary  	 = '通用组件'
  s.homepage     = "https://github.com/pengruiCode/SQRMapLocationList.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = {'pengrui' => 'pengruiCode@163.com'}
  s.source       = { :git => 'https://github.com/pengruiCode/SQRMapLocationList.git', :tag => s.version}
  s.platform 	 = :ios, "8.0"
  s.source_files  = "SQRMapLocationList/**/*.{h,m}"
  s.requires_arc = true
  s.description  = <<-DESC
			基础，通用组件，类扩展以及快捷方法
                   DESC

 end