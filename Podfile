platform :ios, '9.0'

def network
    pod 'Moya'
    pod 'Kingfisher'
    pod 'RealReachability'
end

def data
    pod 'HandyJSON'
    pod 'SwiftyJSON'
    pod 'GRDB.swift'
    pod 'CryptoSwift'
    pod 'RxGRDB'
    pod 'FCUUID'
    pod 'IQKeyboardManagerSwift'
    pod 'Guitar'
    pod 'SwiftyUserDefaults'
end

def resource
    pod 'R.swift'
end

def architecture
   pod 'ReSwift'
   pod 'RxSwift'
   pod 'ObservableArray-RxSwift'
   pod 'RxSwiftExt'
   pod 'RxDataSources'
   pod 'RxKeyboard'
   pod 'RxValidator'
   pod 'Action'

   pod 'Lightning'

   pod 'Localize-Swift'
   pod 'UIFontComplete'
   pod 'RxCocoa'
   pod 'AwaitKit'
end

def permission
    
end

def animation
    pod 'JHChainableAnimations'
    pod 'KRProgressHUD'
end

def extension
    pod 'KeychainAccess'
    pod 'SwifterSwift'
    pod 'Repeat'
end

def ui
    pod 'TinyConstraints'
    pod 'ESTabBarController-swift'
    pod 'KMNavigationBarTransition'
    pod 'IHKeyboardAvoiding'
    pod 'Typist'
    pod 'RxGesture'
    pod 'SwiftRichString', :git => 'https://github.com/malcommac/SwiftRichString', :tag => '2.0.1'
    pod 'ZLaunchAd'
    pod 'SDCAlertView'
    pod 'Presentr'
    pod 'SwiftEntryKit'
    pod 'Keyboard+LayoutGuide'
    pod 'XLPagerTabStrip'
    pod 'EFQRCode'
end

def other
    pod 'Siren'
    pod 'MLeaksFinder'
    pod 'Device'
end

def fabric
    pod 'Fabric'
    pod 'Crashlytics'
end

def debug
    pod 'SwiftyBeaver'
    pod 'Reveal-SDK', :configurations => ['Debug']
end

target 'EOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  
  fabric
  network
  animation
  data
  resource
  architecture
  permission
  extension
  ui
  other
  debug
end
