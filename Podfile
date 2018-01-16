use_frameworks!

target 'TexturePlayground' do
pod 'Texture', '2.6'
pod 'SnapKit', '~> 3.2'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end
