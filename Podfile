platform :ios, '10.0'

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
    pod 'DifferenceKit', :git => 'https://github.com/ra1028/DifferenceKit', :branch => 'master'
    pod 'Dollar'
#    pod 'Validator'
end

def resource
    pod 'R.swift', :git => 'https://github.com/mac-cain13/R.swift', :branch => 'master'
end

def architecture
   pod 'ReSwift'
#   pod 'RxSwift'
#   pod 'ObservableArray-RxSwift'
#   pod 'RxSwiftExt'
#   pod 'RxDataSources'
#   pod 'RxKeyboard'
#   pod 'RxValidator'
#   pod 'Action'

   pod 'Lightning'

   pod 'Localize-Swift'
   pod 'UIFontComplete'
#   pod 'RxCocoa'
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
#    pod 'KRProgressHUD', :git => 'https://github.com/phpmaple/KRProgressHUD', :branch => 'swift4.2'
end

def extension
    pod 'KeychainAccess'
    pod 'SwifterSwift', :git => 'https://github.com/SwifterSwift/SwifterSwift', :branch => 'xcode-10-update'
    pod 'Repeat'
    pod 'AsyncSwift'
end

def ui
    pod 'TagListView', :git => 'https://github.com/ElaWorkshop/TagListView', :branch => 'master'
    pod 'TinyConstraints', :git => 'https://github.com/roberthein/TinyConstraints', :branch => 'release/Swift-4.2'
#    pod 'IHKeyboardAvoiding'
#    pod 'Typist'
#    pod 'RxGesture'
    pod 'SwiftRichString', :git => 'https://github.com/mezhevikin/SwiftRichString', :branch => 'swift4.2', :inhibit_warnings => true
    #    pod 'ZLaunchAd'
    pod 'SDCAlertView', :git => 'https://github.com/sberrevoets/SDCAlertView', :branch => 'swift-4.2'
    pod 'Presentr'
#    pod 'SwiftEntryKit'
#    pod 'Keyboard+LayoutGuide'
#    pod 'XLPagerTabStrip'
    pod 'EFQRCode'
#    pod 'FSPagerView' #轮播图
    pod 'ESPullToRefresh', :git => 'https://github.com/phpmaple/pull-to-refresh', :branch => 'swift-4.2'
    pod 'KUIPopOver'
    pod 'GrowingTextView', :git => 'https://github.com/phpmaple/GrowingTextView', :branch => 'swift4.2'
    pod 'Bartinter'
#    pod 'NotificationBannerSwift', :git => 'https://github.com/phpmaple/NotificationBanner', :branch => 'swift4.2'
#    pod 'ActiveLabel'
#    pod 'UINavigationItem+Margin'
end

def other
    pod 'Siren'
    #pod 'MLeaksFinder'
    pod 'Device'
    pod 'SwiftNotificationCenter'
    pod 'MonkeyKing', :git => 'https://github.com/nixzhu/MonkeyKing', :branch => 'master'
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
