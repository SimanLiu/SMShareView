Pod::Spec.new do |s|
s.name         = 'SMShareView'
s.version      = '1.0.0'
s.summary      = '仿微信分享面板'
s.homepage     = 'https://github.com/SimanLiu/SMShareView'
s.license      = 'MIT'
s.authors      = {'Siman' => 'liu276785663@163.com'}
s.platform     = :ios, '8.0'
s.source_files = SMShareView/**/*.{h,m}
s.source       = {:git => 'https://github.com/SimanLiu/SMShareView.git', :tag => s.version}
s.requires_arc = true
end

