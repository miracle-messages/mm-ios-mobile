source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'MiracleMessages' do
    pod 'AWSS3'
#    pod 'CameraEngine', :git => 'https://github.com/remirobert/CameraEngine.git', :branch => 'master'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
