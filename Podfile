source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'

use_frameworks!

post_install do |installer|
        installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2' # or '4.2'
        end
    end
end

def third_party_pods
    pod 'RealmSwift', :inhibit_warnings => true
end

target 'Challenge' do
    third_party_pods
end
