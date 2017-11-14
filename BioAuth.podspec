Pod::Spec.new do |s|
  s.name             = "BioAuth"
  s.version          = "1.0.0"
  s.summary          = "A delightful Biometrics Authenticating framework written in Swift"
  s.description      = <<-DESC
                        A delightful Biometrics Authenticating framework for iOS platforms written in Swift.
                        DESC

  s.homepage         = "https://github.com/Meniny/BioAuthenticator"
  s.license          = 'MIT'
  s.author           = { "Meniny" => "Meniny@qq.com" }
  s.source           = { :git => "https://github.com/Meniny/BioAuthenticator.git", :tag => s.version.to_s }
  s.social_media_url = 'http://meniny.cn/'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BioAuthenticator/**/*{.h}','BioAuthenticator/**/*{.swift}'
  s.public_header_files = 'BioAuthenticator/**/*{.h}'

  s.frameworks = 'Foundation', 'LocalAuthentication'
end
