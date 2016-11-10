source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'MiracleMessages' do
    pod 'AWSS3'
    pod 'HockeySDK', '~> 4.1.2'
#    pod 'CameraEngine', :git => 'https://github.com/remirobert/CameraEngine.git', :branch => 'master'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'DatePickerDialog'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
