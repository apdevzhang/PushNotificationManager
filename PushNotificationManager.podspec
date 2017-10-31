Pod::Spec.new do |s|
  s.name         = "PushNotificationManager"
  s.version      = "1.0.2"
  s.summary      = "Convenient and comprehensive api for push notification"
  s.description  = <<-DESC
Convenient and comprehensive api for push notification,provide 6 stems and 20 branchs' function,offer examples written by Objective-C and Swift respectively
                   DESC
  s.homepage     = "https://github.com/GREENBANYAN/PushNotificationManager"
  s.license      = "MIT"
  s.author             = { "GREENBANYAN" => "@greenbanyan@163.com" }
  s.platform     = :ios,'8.0'
  s.source       = { :git => "https://github.com/GREENBANYAN/PushNotificationManager.git", :tag => "#{s.version}" }
  s.source_files  = "PushNotificationManager/*.{h,m}"
  s.requires_arc = true
end
