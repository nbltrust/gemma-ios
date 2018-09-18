platform :ios, '9.0'

def network
end

def data
    pod 'SwiftyJSON'
#    pod 'GRDB.swift'
    pod 'CryptoSwift'
#    pod 'RxGRDB'
    pod 'IQKeyboardManagerSwift'
    pod 'Guitar'
    pod 'SwiftyUserDefaults',:git => 'https://github.com/radex/SwiftyUserDefaults', :tag => '4.0.0-alpha.1'
    pod 'SwiftDate'
    pod 'DifferenceKit'
    pod 'Dollar'
    pod 'Validator'
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
   pod 'Hydra'
#   pod 'Aspects'
end

def permission
    pod 'Proposer'
    pod 'BiometricAuthentication'
end

def animation
    pod 'JHChainableAnimations'
    pod 'KRProgressHUD'
end

def extension
    pod 'KeychainAccess'
    pod 'SwifterSwift'
    pod 'Repeat'
    pod 'AsyncSwift'
end

def ui
    pod 'TagListView' #助记词
    pod 'TinyConstraints'
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
    pod 'FSPagerView' #轮播图
    pod 'ESPullToRefresh'
    pod 'KUIPopOver'
    pod 'GrowingTextView'
    pod 'Bartinter'
    pod 'NotificationBannerSwift'
    pod 'ActiveLabel'
#    pod 'UINavigationItem+Margin'
end

def other
    pod 'Siren'
    #pod 'MLeaksFinder'
    pod 'Device'
    pod 'SwiftNotificationCenter'
    pod 'MonkeyKing'
    pod 'FGRoute'
end

def fabric
    pod 'Fabric'
    pod 'Crashlytics'
end

def debug
    pod 'SwiftyBeaver'
    pod 'Reveal-SDK', :configurations => ['Debug']
    pod 'CocoaDebug', :configurations => ['Debug']
end

def objc
    pod 'RealReachability'
    pod 'KMNavigationBarTransition'
    pod 'FCUUID'
end

target 'EOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
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
  objc
  
  target 'EOSTests' do
      inherit! :search_paths
      # Pods for testing
      pod 'Nimble'
      pod 'Quick'
  end

end
