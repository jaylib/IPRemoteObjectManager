Pod::Spec.new do |s|
  s.name         = "IPRemoteObjectManager"
  s.version      = "0.5"
  s.summary      = "Download Manager Queue"
  s.description  = <<-DESC
                   Download Manager with nested grouping support
                   DESC
  s.homepage     = "http://github.com/jaylib/IPRemoteObjectManager"
  s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "Josef Materi" => "josef.materi@gmail.com" }
  s.source       = { :git => "https://github.com/jaylib/IPRemoteObjectManager.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'IPRemoteObjectManager/Classes/*.{h,m}'
  s.dependency 'AFNetworking'
  s.dependency 'ReactiveCocoa'
  s.dependency 'AFNetworking-RACExtensions'
end
