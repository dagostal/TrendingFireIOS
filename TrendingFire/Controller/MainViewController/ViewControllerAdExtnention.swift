//
//  AdLoaderExtnention.swift
//  TrendingFire
//
//  Created by alex on 4/12/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//


import UIKit
import GoogleMobileAds

extension ViewController: GADAdLoaderDelegate,GADUnifiedNativeAdLoaderDelegate,GADUnifiedNativeAdDelegate {
    func setUpAdLoadForCard(){
        var adTypes = [GADAdLoaderAdType]()
        adTypes.append(.unifiedNative)
        adLoader = GADAdLoader(
          adUnitID: "ca-app-pub-2312447022233574/9464795746", rootViewController: self,
          adTypes: adTypes, options: [])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("ERROR receiving ad",error)
    }
    func adLoader(_ adLoader: GADAdLoader,didReceive nativeAd: GADUnifiedNativeAd) {
        print("ad has loaded:",nativeAd)
        self.loadedNativeAdForCycle = nativeAd
      // A unified native ad has loaded, and can be displayed.
    }

    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("ad loader is done")
        // The adLoader has finished loading ads, and a new request can be sent.
    }


    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("the ad was shown!")
      // The native ad was shown.
    }

    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad was clicked on.
        print("the ad was clicked!")
    }
    

    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad will present a full screen view.
        print("the ad was clicked to full screen!")
    }

    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad will dismiss a full screen view.
        print("the ad was dismissed")
    }

    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad did dismiss a full screen view.
        print("the ad was dismissed full screen")
    }

    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad will cause the application to become inactive and
        print("the ad is going to a new app")
      // open a new application.
    }
    func adLoader(_ adLoader: GADAdLoader,didReceive nativeCustomTemplateAd: GADNativeCustomTemplateAd) {
        print("GOT AD")
    }
    
}
