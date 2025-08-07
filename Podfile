platform :ios, '13.0'

target 'Pokedex' do
  use_frameworks!

  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxRealm'
  pod 'MBProgressHUD'
  pod 'XLPagerTabStrip', '~> 9.0'
  pod 'RealmSwift'
  pod 'netfox'
  pod 'Sodium'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
