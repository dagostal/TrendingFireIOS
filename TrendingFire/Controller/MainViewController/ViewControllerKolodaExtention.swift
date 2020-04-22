//
//  ViewControllerKolodaExtention.swift
//  TrendingFire
//
//  Created by alex on 4/11/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit
import GoogleMobileAds

extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        resetDeck(selectedCat:self.selectedCategories)
    }
    
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return 0.1
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int,tappedBottomRight: Bool) {
        if(cardIsTapped != true) {
            addInfoBoxView(title:self.dataSource[index].title,author: self.dataSource[index].authorTxt, description: self.dataSource[index].descText, rank: self.dataSource[index].rankTxt, link: self.dataSource[index].link)
            cardIsTapped = true
        }
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
            return [.up,.left,.right]
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print(index)
        if(index == 10) {
            let adHolder:GADUnifiedNativeAdView = GADUnifiedNativeAdView()
            if (self.loadedNativeAdForCycle != nil) {
                self.loadedNativeAdForCycle!.delegate = self
                self.myKolodaView.adAdViewToCard(adView: adHolder,nativeAd:self.loadedNativeAdForCycle!)
            }
        }
        removeCardDesc()
        if(self.loggedIn == true) {
            postSwipe(swipeVal: direction.rawValue, userIdVal: self.userID)
        }
    }
}

// MARK: KolodaViewDataSource

extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image:dataSource[index].image)
    }
}
