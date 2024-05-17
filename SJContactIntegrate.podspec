
Pod::Spec.new do |s|
    s.name         = 'SJContactIntegrate'
    s.version      = '3.4.4'
    s.summary      = 'video player.'
    s.description  = 'https://github.com/changsanjiang/SJContactIntegrate/blob/master/README.md'
    s.homepage     = 'https://github.com/changsanjiang/SJContactIntegrate'
    s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
    s.author       = { 'SanJiang' => 'changsanjiang@gmail.com' }
    s.platform     = :ios, '12.0'
    s.source       = { :git => 'https://github.com/KyleWhale/SJContactIntegrate.git', :tag => "v#{s.version}" }
    s.requires_arc = true
    s.dependency 'SJBaseSequenceInvolve'

    s.source_files = 'SJContactIntegrate/*.{h,m}'
    
    s.subspec 'Common' do |ss|
      ss.source_files = 'SJContactIntegrate/Common/**/*'
      ss.dependency 'Masonry'
      ss.dependency 'SJBaseSequenceInvolve'
      ss.dependency 'SJUIKit/AttributesFactory'
      ss.dependency 'SJContactIntegrate/ResourceLoader'
    end
    
    s.subspec 'ControlLayers' do |ss|
      ss.source_files = 'SJContactIntegrate/ControlLayers/**/*'
      ss.dependency 'SJContactIntegrate/Common'
    end
    
    s.subspec 'ResourceLoader' do |ss|
      ss.source_files = 'SJContactIntegrate/ResourceLoader/*.{h,m}'
      ss.resource = 'SJContactIntegrate/ResourceLoader/SJContactIntegrate.bundle'
    end
end
