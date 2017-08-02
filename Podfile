source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'MiracleMessages' do
    pod 'AWSS3'
    pod 'HockeySDK', '~> 4.1.2'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'DatePickerDialog'
    pod 'SCLAlertView'
    pod 'Alamofire', '~> 4.0'
    pod 'Firebase/Auth'
    pod 'Firebase/Storage'
    pod 'GoogleSignIn'
    pod 'Fabric', :inhibit_warnings => true
    pod 'Crashlytics'
    pod 'SnapKit', '~> 3.2.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
