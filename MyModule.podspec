# MyModule.podspec
Pod::Spec.new do |s|
    s.name         = 'MyModule'
    s.version      = '0.1.0'
    s.summary      = 'A module that depends on older SA* libraries.'
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.authors      = { 'Author Name' => 'author@example.com' }
    s.homepage     = 'https://example.com/MyModule'
    s.platform     = :ios, '10.0'
    s.source       = { :git => 'https://example.com/MyModule.git', :tag => s.version }
    s.swift_version = '5.0'

    # Dependencies with older constraints
    s.dependency 'SAAnalytics', '~> 1.0'
    s.dependency 'SANetwork', '~> 1.1'
    s.dependency 'SACoordinator','~> 2.2'
    s.dependency 'SAWorkspace', '~> 1.5'
end
