# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def rxswift_pods
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
end

def rx_pods
  rxswift_pods
  pod 'RxGesture', '~> 4.0.2'
  pod 'RxSwiftExt'
  pod 'RxDataSources'
  pod 'XCoordinator', '~> 2.0'
end

def networking_pods
  pod 'Kingfisher', '7.2.0'
end

def local_database_pods
  pod 'RealmSwift', '~> 10'
end

def app_pods
  pod 'Resolver', '~> 1.4.3'
  pod 'R.swift'
  pod 'SnapKit'
  pod 'ReachabilitySwift'
end

target 'AppetiserInterview' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AppetiserInterview
  rx_pods
  app_pods
  
  target 'DNNetworkPlatform' do
    rxswift_pods
    networking_pods
  end
  
  target 'DNDomain' do
    rxswift_pods
  end
  
  target 'DNRealmPlatform' do
    rxswift_pods
    local_database_pods
  end
end
