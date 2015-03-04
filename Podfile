platform :ios, "8.0"
inhibit_all_warnings!

target "wormhole" do
end

target "wormholeTests" do
  pod 'Specta', '~> 0.3.2'
  pod 'Expecta', '~> 0.3.2'
  pod 'OHHTTPStubs', '~> 3.1.0'
  pod 'OCMock', '~> 3.1.1'
end

# Workaround for XCtest.h that isn't found on Xcode 6
post_install do |installer|
    targets = installer.project.targets.find_all { |t| t.to_s.start_with?  "Pods-" }
    targets.each do |target|
        target.build_configurations.each do |config|
            s = config.build_settings['FRAMEWORK_SEARCH_PATHS']
            s = [ '$(inherited)' ] if s == nil;
            s.push('$(PLATFORM_DIR)/Developer/Library/Frameworks')
            config.build_settings['FRAMEWORK_SEARCH_PATHS'] = s
        end
    end
end
