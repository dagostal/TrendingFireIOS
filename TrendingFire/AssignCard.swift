//
//  assignCards.swift
//  TrendingFire
//
//  Created by alex on 12/10/19.
//  Copyright © 2019 Alex D'Agostino. All rights reserved.
//

import Foundation



func assignCards(self:UIViewController,arr: [[String:String]],reff:Bool) {
    if(reff == true) {
        
        //for some reason the way the code is structured base don indexCoutn countof cards of koloda... the best thing to do here is append to data source. but edventually things would slow down, it should just be set new. but that would require writing functions to change count of koloda and all of that.
        //does appending datasource consistnely reset variables? because it is a setterz
        print("setting up additional cards. appending data source")
        
        print("datasource count: \(self.dataSource.count)")
        for i in 0..<arr.count {
            dataSource.append(arr[i])
        }

        print("datasource count: \(self.dataSource.count)")
        let position = myKolodaView.currentCardIndex
        myKolodaView.insertCardAtIndexRange(position..<position + (arr.count), animated: true)
        loadingView.removeFromSuperview()

    } else {
       print("setting up initial deck..")
        self.dataSource = arr

        setUpKoloda()
        myKolodaView.delegate = self
        myKolodaView.dataSource = self
        myKolodaView.visibleCardsDirection = .top
        loadingView.removeFromSuperview()
    }
}
