# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

workspace :ReactiveExamples

def common_dependencies
	script_phase :name => 'Run SwiftLint', :script => '"${PODS_ROOT}/SwiftLint/swiftlint" --config ../.swiftlint.yml', :execution_position => :before_compile

	pod 'SwiftLint'
end

target :API do
	project 'API/API.xcodeproj'

	common_dependencies
end

target :ReferenceExample do
	project 'ReferenceExample/ReferenceExample.xcodeproj'

	common_dependencies
end

target :ReactiveSwiftExample do
	project 'ReactiveSwiftExample/ReactiveSwiftExample.xcodeproj'

	common_dependencies
	pod 'ReactiveSwift', '~> 6.0'
	pod 'ReactiveCocoa', '~> 10.0'
end

target :RxSwiftExample do
	project 'RxSwiftExample/RxSwiftExample.xcodeproj'

	common_dependencies
	pod 'RxSwift', '~> 5.0'
	pod 'RxCocoa', '~> 5.0'
	pod 'Action'
end
