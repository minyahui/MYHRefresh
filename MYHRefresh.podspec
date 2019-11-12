Pod::Spec.new do |spec|
  spec.name         = "MYHRefresh"
  spec.version      = "1.0.1"
  spec.summary      = "An easy way to use pull-to-refresh base on MJRefresh"
  spec.homepage     = "https://github.com/minyahui/MYHRefresh"
  spec.license      = 'MIT'
  spec.author             = { "minyahui" => "1036166261@qq.com" }
  spec.platform     = :ios, "8.0"
  spec.swift_version = '5.0'
  spec.source       = { :git => "https://github.com/minyahui/MYHRefresh.git", :tag => "#{spec.version}" }
  spec.source_files  = "MYHRefresh/**/*.{swift}"
  spec.resource  = "MYHRefresh/MYHRefresh.bundle"
  spec.requires_arc = true
end
