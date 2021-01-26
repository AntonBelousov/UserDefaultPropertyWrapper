Pod::Spec.new do |s|
    s.name        = "UserDefaultPropertyWrapper"
    s.version     = "0.9.0"
    s.summary     = "UserDefaultPropertyWrapper"
    s.homepage    = "https://github.com/AntonBelousov/UserDefaultPropertyWrapper"
    s.license     = { :type => "MIT" }
    s.authors     = { "AntonBelousov" => "xxx@yyy.com" }

    s.requires_arc = true
    s.ios.deployment_target = "8.0"
    s.watchos.deployment_target = "4.0"
    s.swift_version = '5.3'

    s.source   = { :git => "https://github.com/AntonBelousov/UserDefaultPropertyWrapper.git", :tag => s.version }
    s.source_files = "Source/*.swift"
end
