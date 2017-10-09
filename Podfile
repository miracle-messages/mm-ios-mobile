source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'MiracleMessages' do
    pod 'Alamofire', '~> 4.0'
    pod 'AWSS3', '~> 2.6'
    pod 'Crashlytics', '~> 3.8'
    pod 'DatePickerDialog', '~> 2.0'
    pod 'Fabric', '~> 1.6.13', :inhibit_warnings => true
    pod 'Firebase', '~> 4.2'
    pod 'FirebaseCore', '~> 4.0'
    pod 'FirebaseAuth', '~> 4.2'
    pod 'FirebaseDatabase', '~> 4.0'
    pod 'FirebaseStorage', '~> 2.0'
    pod 'GoogleSignIn', '~> 4.1'
    pod 'HockeySDK', '~> 4.1'
    pod 'Nuke', '~> 5.2'
    pod 'SCLAlertView', '~> 0.7'
    pod 'SnapKit', '~> 3.2'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
