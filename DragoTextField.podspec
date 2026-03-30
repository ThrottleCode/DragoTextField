Pod::Spec.new do |spec|

  spec.name         = "DragoTextField"
  spec.version      = "1.0.0"
  spec.summary      = "A customisable UITextField wrapper for iOS."

  spec.description  = <<-DESC
    DragoTextField is a fully customisable UITextField wrapper for iOS.
    Supports floating title labels, custom border, padding, max length,
    secure text entry, editing callbacks and much more.
    Distributed via Swift Package Manager and CocoaPods.
  DESC

  spec.homepage     = "https://github.com/ThrottleCode/DragoTextField"
  spec.screenshots  = "https://raw.githubusercontent.com/ThrottleCode/DragoTextField/main/Screenshots/preview1.png",
                      "https://raw.githubusercontent.com/ThrottleCode/DragoTextField/main/Screenshots/preview2.png"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "Amandeep Singh" => "Amansandhu14299@gmail.com" }

  spec.ios.deployment_target = "14.0"
  spec.swift_version = "5.9"

  spec.source       = { :git => "https://github.com/ThrottleCode/DragoTextField.git", :tag => "#{spec.version}" }

  spec.source_files = "Sources/DragoTextField/**/*.swift"

end
