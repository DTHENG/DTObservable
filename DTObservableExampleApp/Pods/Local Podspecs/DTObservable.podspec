#
# Be sure to run `pod lib lint DTObservable.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DTObservable"
  s.version          = "0.1.0"
  s.summary          = "An simple observable structure for iOS."
  s.description      = <<-DESC
# DTObservable

Implementation of the observable chain methodology for iOS.
  
                     DESC
  s.homepage         = "https://github.com/DTHENG/DTObservable"
  s.license          = 'MIT'
  s.author           = { "DTHENG" => "fender5289@gmail.com" }
  s.source           = { :git => "https://github.com/DTHENG/DTObservable.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = '*.{h,m}'
  s.resource_bundles = {
    'DTObservable' => ['Pod/Assets/*.png']
  }

end
