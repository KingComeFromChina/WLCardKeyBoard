

Pod::Spec.new do |s|

  s.name         = "WLCardKeyBoard"
  s.version      = "0.0.1"
  s.summary      = "Create ID Card keyboard by swift"
  s.description  = <<-DESC
                  Create ID Card keyboard by swift
                   DESC
  s.homepage     = "https://github.com/KingComeFromChina/WLCardKeyBoard"
  s.license      = "MIT"
  s.author             = { "wanglei" => "KingComeFromChina@gmail.com" }
  
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/KingComeFromChina/WLCardKeyBoard.git", :tag => s.version }

  s.source_files  = "WLCardKeyBoard/"
  
  s.requires_arc = true

  

end
