Pod::Spec.new do |s|

  s.name         = "BRReusableQueue"
  s.module_name  = "BRReusableQueue"
  s.version      = "0.0.2"
  s.summary      = "ReusableQueue is a simple, private api free queue you can use to reuse every object."

  s.description  = <<-DESC
                    Whenever you struggle with performance of the creation of certain objects try to reuse them. This queue helps you to reuse every object you need to.
                   DESC

  s.homepage     = "https://github.com/brototyp/BRReusableQueue"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Cornelius Horstmann" => "site-cocoapod@brototyp.de" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/brototyp/BRReusableQueue.git", :tag => "0.0.2" }
  s.source_files = "BRReusableQueue"

end
