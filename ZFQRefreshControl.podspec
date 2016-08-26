Pod::Spec.new do |s|

	s.name = "ZFQRefreshControl"
	s.version  = "1.2"
	s.description = <<-DESC
							仿知乎的加载上一篇或下一篇的控件，实现原理参考了MJRefresh
							DESC
	s.summary = "上拉下拉刷新控件"
	s.source = { :git => "https://github.com/zfq/RefreshControl" }
	
	s.homepage     = "https://github.com/zfq/RefreshControl"
	s.license      = "MIT"
	s.author       = { "zhaofuqiang" => "1586687169zfq@gmail.com" }
				
	s.platform     = :ios
	s.platform     = :ios, "7.0"
	s.requires_arc = true
	s.source_files = 'RefreshControl/','仿知乎加载/仿知乎加载/ZFQLoadFrontOrNextView/*.{h,m}'
	
end
