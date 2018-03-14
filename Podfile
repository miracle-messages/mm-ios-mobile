source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'MiracleMessages' do
    pod 'Alamofire'
    pod 'AWSS3'
    pod 'Crashlytics'
    pod 'DatePickerDialog'
    pod 'Fabric'
    pod 'Firebase'
    pod 'FirebaseCore'
    pod 'FirebaseAuth'
    pod 'FirebaseDatabase'
    pod 'FirebaseStorage'
    pod 'GoogleSignIn'
    pod 'HockeySDK'
    pod 'Nuke'
    pod 'SCLAlertView'
    pod 'SnapKit'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4'
        end
    end
end
